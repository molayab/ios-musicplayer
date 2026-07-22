# Core architecture, in diagrams

A visual companion to [`docs/agents/architecture.md`](agents/architecture.md)
and [`docs/agents/viability.md`](agents/viability.md) — same content, drawn
out. Renders directly on GitHub (these are plain Mermaid fences).

## 1. What the old model couldn't do

Before this re-architecture, `Core` had one playback abstraction: `Player` —
a single queue, skip next/previous, one `nowPlaying`. Fine for a
Music.app-style player; structurally incapable of two decks playing into a
crossfader at once, which is the entire point of a DJ app.

```mermaid
flowchart LR
    Scenes["Scenes and Presenters"] --> Player["Player — one queue"]
    Player --> Now["nowPlaying: Playable?"]
    Player -.->|"structurally cannot represent"| TwoDecks["deck A + deck B, playing at once"]
```

## 2. The split: local engine primary, Apple Music a bridge

Local files are fully controllable — raw PCM via `AVAudioEngine`, so cue
points, tempo, gain, and true simultaneous playback are all possible. Apple
Music catalog tracks are DRM-protected — Apple's own player is the only
legal path to them, a single black-box stream by platform policy, not by
choice. The single-queue shape that was wrong for decks is exactly right for
that bridge, so it moved rather than got rewritten. See
[`docs/agents/viability.md`](agents/viability.md) for the full reasoning.

```mermaid
flowchart TB
    Scenes["Scenes and Presenters — App / UI"]

    subgraph DJ["LOCAL DJ ENGINE — primary, full control"]
        direction TB
        MS["MixingSession — actor"]
        AED["AudioEngineDeck x2 — internal, non-actor"]
        TRK["Track"]
        TI["TrackImporter"]
        LLS["LocalLibraryStore"]
        TA["TrackAnalyzer — unimplemented"]
        MS --> AED
        TI --> TRK --> LLS
    end

    subgraph AMB["APPLE MUSIC BRIDGE — secondary, DRM-limited"]
        direction TB
        PC["PlayerController"]
        QR["Query"]
        BQP["BuiltInQueryProvider"]
        BMP["BuiltInMusicPlayerProvider — stub"]
        PC --> BMP
        QR --> BQP
    end

    Scenes -->|"raw PCM, own files"| MS
    Scenes -->|"browse and listen only"| PC

    classDef dj fill:#fdecd9,stroke:#d9722c,color:#5c3312;
    classDef amb fill:#dcf1f3,stroke:#2f8f9c,color:#0f3a3f;
    classDef stub stroke-dasharray: 4 3;
    class MS,AED,TRK,TI,LLS,TA dj;
    class PC,QR,BQP,BMP amb;
    class TA,BMP stub;
```

Dashed outline = scoped but not implemented (`TrackAnalyzer`,
`BuiltInMusicPlayerProvider`).

## 3. Why one actor, not two

First pass gave each deck its own `actor`, both holding a reference to one
shared `AVAudioEngine`. Swift 6 rejected it: `AVAudioEngine` isn't
`Sendable`, and nothing stops two actors from touching the same mutable
graph from different threads at once — the compiler is right to refuse
that. The fix isn't a suppression, it's a smaller graph of authority: one
actor owns the entire engine and both decks; the decks themselves become
plain internal classes that only that actor ever touches. See
`Core/AudioEngine/MixingSession.swift`'s header comment for the same
reasoning in prose, and
[`docs/agents/conventions.md`](agents/conventions.md#swift-6-concurrency)
for the general pattern.

```mermaid
flowchart TB
    subgraph REJ["REJECTED — two actors share one engine"]
        direction LR
        A1["actor AudioEngineDeck A"]
        A2["actor AudioEngineDeck B"]
        E1["AVAudioEngine — not Sendable"]
        A1 -.-> E1
        A2 -.-> E1
        E1 -.->|"sending self.engine risks<br/>causing data races"| ERR["compiler error"]
    end

    subgraph ACC["ACCEPTED — one actor owns the graph"]
        direction LR
        M["actor MixingSession"]
        DA["AudioEngineDeck A — internal class"]
        DB["AudioEngineDeck B — internal class"]
        E2["AVAudioEngine"]
        M --> DA
        M --> DB
        DA --> E2
        DB --> E2
    end

    classDef rej fill:#fbe4e1,stroke:#c94f42,color:#5c1b13;
    classDef acc fill:#e3f2e6,stroke:#4a9459,color:#173d1e;
    class A1,A2,E1,ERR rej;
    class M,DA,DB,E2 acc;
```

## 4. Signal flow: importing a track

Nothing on iOS grants ambient filesystem access, so a file has to be
explicitly picked, bookmarked, and read for metadata before it becomes a
`Track` the library can hold onto across launches. The picker UI itself is
the one piece not built yet — `FileTrackImporter` is ready to receive
whatever URLs it's handed.

```mermaid
sequenceDiagram
    actor User
    participant Picker as Document picker<br/>(App/UI — not built yet)
    participant TI as FileTrackImporter
    participant Asset as AVURLAsset
    participant Store as FileLocalLibraryStore

    User->>Picker: choose audio files
    Picker->>TI: importTracks(from: urls)
    loop each URL
        TI->>TI: startAccessingSecurityScopedResource()
        TI->>Asset: load duration + common metadata
        Asset-->>TI: title, artist, album, duration
        TI->>TI: url.bookmarkData()
        TI-->>Picker: Result of Track or Error
    end
    Picker->>Store: add(tracks)
    Note over Store: persisted to<br/>LocalLibrary.json
```

One `Result` per file — a bad track in a batch import doesn't sink the rest.

## 5. Signal flow: mixing two decks

Every call into `MixingSession` crosses an actor boundary, so it's
`await`-ed from the app side — the same serialization that made the
engine-sharing problem in section 3 disappear is what makes this safe to
call from a SwiftUI presenter without any manual locking.

```mermaid
sequenceDiagram
    participant App as App presenter
    participant MS as MixingSession (actor)
    participant DA as deck .a
    participant DB as deck .b
    participant Engine as AVAudioEngine

    App->>MS: await load(trackA, into: .a)
    MS->>DA: load(trackA)
    DA->>Engine: attach + connect nodes
    App->>MS: await load(trackB, into: .b)
    MS->>DB: load(trackB)
    App->>MS: await play(.a)
    MS->>DA: play()
    DA->>Engine: playerNode.play()
    App->>MS: await setCrossfade(0.7)
    MS->>DA: setGain(0.3)
    MS->>DB: setGain(0.7)
    Note over DA,DB: both decks audible,<br/>blended by the crossfader
```

## 6. Status board

What actually runs today versus what's scaffolded for later. Kept in sync
with [`docs/agents/state.md`](agents/state.md) — that file is the source of
truth if the two ever disagree.

| Component | Status | Note |
|---|---|---|
| `MixingSession` / `AudioEngineDeck` | ✅ Implemented | Real `AVAudioEngine` graph; not yet exercised against a live file in a running app. |
| `Track` / `FileTrackImporter` | ✅ Implemented | Bookmark + `AVAsset` metadata. No picker UI feeding it yet. |
| `FileLocalLibraryStore` | ✅ Implemented | JSON file under Application Support. Nothing reads from it yet. |
| `TrackAnalyzer` (BPM / key) | 🟠 Scoped, not built | Protocol exists; `UnimplementedTrackAnalyzer` always returns nothing. No first-party API, real DSP work. |
| `BuiltInQueryProvider` | ✅ Implemented | Wraps `MPMediaQuery` — system Music library, not arbitrary files. |
| `BuiltInMusicPlayerProvider` | 🔴 Stub | `Query` doesn't retain the `MPMediaItem` needed to build a real queue yet. |
| Document picker / import UI | ⬜ Not built | App/UI concern, deliberately out of this pass. |
| Deck / mixer screen | ⬜ Not built | No SwiftUI surface calls into `MixingSession` yet. |
