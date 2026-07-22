# Viability investigation: pivot to a local-file DJ library player

Status: **decided and partially implemented.** `Core` was re-architected
along the lines this document recommends (see the Verdict section below for
exactly what landed vs. what's still open). This document is kept as the
decision record — an agent touching `Core` should still read it before
assuming the shape of things, since several parts (BPM/key analysis, App-
layer UI, the Apple Music bridge player) remain intentionally unbuilt.

## The pivot being considered

Move the product goal from "third-party Music.app replacement" (2020 README) to:

> A music player built **DJ-library-first**: the user's own local audio files,
> imported and fully controlled by the app, with DJ-relevant features (cue
> points, waveforms, BPM, crossfading). Apple Music support is a **secondary,
> best-effort bridge** for subscribers — browsing/listening convenience only,
> not part of the mixing surface.

## Why the current `Core` can't just be repointed at local files

The existing abstraction (`Core/Player.swift`, `Core/Query.swift`,
`Core/Playable.swift`, `Core/PlayerController.swift`) and its only concrete
implementation (`Core/Providers/BuiltInQueryProvider.swift`) are built on
`MediaPlayer` (`MPMediaQuery`, implicitly `MPMusicPlayerController`). That API
has three consequences for this pivot:

1. **`MPMediaQuery` is not a file picker.** It only sees items already synced
   into the device's system Music library (Finder sync, iTunes purchases,
   iCloud Music Library additions). It has no relationship to arbitrary files
   a DJ has on a drive, in Files.app, or in iCloud Drive. Building "import my
   own MP3/WAV/FLAC set" on top of it is not possible — a different, new
   subsystem is required (see below).
2. **DRM blocks raw audio access for Apple Music catalog tracks.** Any
   `MPMediaItem`/`MusicKit` song that comes from the Apple Music catalog
   (streamed or "added" to the library, not purchased/ripped by the user) is
   protected content. Apple's playback path (`MPMusicPlayerController` /
   `ApplicationMusicPlayer` / `SystemMusicPlayer`) is a black box by design:
   no PCM buffer access, no waveform data, no custom EQ/pitch/time-stretch,
   no simultaneous two-deck playback. This is a platform policy limit, not a
   bug — it will never be available through public API. **Anything
   DJ-grade is only possible for the user's own unprotected local files.**
3. **`Player` models one sequential stream, not a mixer.** `Player.setQueue`,
   `skipNext`/`skipPrevious`, and a single `nowPlaying: Playable?` describe a
   Music.app-style single queue. DJ mixing needs **two or more simultaneously
   loaded, independently transported decks** with a shared crossfader — a
   fundamentally different shape than "one active `Playable`". The protocol
   needs redesigning around a deck/session model, not a queue.

`Core/README.md` already documents this as a known limitation ("you can only
have ONE provider working at the same time... LIKE-IMPOSSIBLE to create a
shared queue with mixed content") — written when the assumption was
Apple-Music-vs-Spotify-style provider swapping. Under the DJ pivot this
constraint actually **inverts**: local files can absolutely be mixed
simultaneously (it's just `AVAudioEngine` nodes), it's Apple Music that stays
capped at "one system-level black-box stream at a time."

## What local-file playback actually requires (net-new work)

None of this exists in the repo yet — `BuiltInMusicPlayerProvider` is a
literal empty stub. Required subsystems:

- **File import**: `UIDocumentPickerViewController` / drag-and-drop / a share
  extension, since iOS gives no ambient filesystem access. Files can be
  copied into the app's sandbox (durable, iCloud-backed up) or kept in place
  via security-scoped bookmarks (needed for large DJ libraries on external
  drives; bookmarks can go stale and need re-resolution — plan for that UX).
- **Playback engine**: `AVAudioEngine` + `AVAudioPlayerNode` + `AVAudioFile`,
  not `AVPlayer`/`MPMusicPlayerController`. This is what unlocks raw PCM
  access for waveforms, gain/EQ nodes, time-pitch (`AVAudioUnitTimePitch`),
  looping, cue points, and multi-deck simultaneous output.
- **Format coverage**: MP3, AAC/M4A, ALAC, AIFF, WAV, FLAC are all readable
  via `AVAudioFile`/`AVAsset` — good general DJ format coverage without extra
  decoding libraries.
- **Metadata**: ID3/M4A tags via `AVAsset`/`AVMetadataItem` cover
  title/artist/album/artwork. **BPM/musical key are not provided by any
  Apple API** — needs custom DSP (onset/beat detection) or a bundled
  analysis library; scope this explicitly, it's the single biggest unknown
  in the whole pivot.
- **Library persistence**: today there's no local database at all — `Query`
  is a live wrapper over `MPMediaQuery`. A local-file library needs its own
  index (e.g. a lightweight store, SwiftData/Core Data/SQLite) tracking
  imported file locations/bookmarks, tags, cue points, and play history.

## Where Apple Music can still fit (secondary bridge, not core)

- Use `MusicKit`(iOS 15+ `MusicAuthorization`, `ApplicationMusicPlayer`) gated
  behind an entitlement check and clearly separated UI, for subscribers who
  want to browse/queue catalog tracks like a normal player.
  `MPMediaQuery`/`MPMusicPlayerController` are the legacy iOS 14-era
  equivalent the current code already leans on; either is fine for this
  reduced "convenience" role, but MusicKit is the actively maintained one.
- Explicitly **exclude** Apple Music tracks from decks/cues/waveforms/BPM —
  not a missing feature, a platform constraint. Document that in-product so
  it isn't reported as a bug.
- `NSAppleMusicUsageDescription` is already present in `App/Info.plist`, so
  the capability request plumbing has a head start; a `MusicKit`
  entitlement/capability still needs to be added in Xcode/`project.yml` when
  this bridge is built.

## Verdict

Feasible as an indie-scale project, and this was a **re-architecture of
`Core`, not an extension of it**. What happened against the original
recommended sequencing:

1. **Done.** `Core`'s player abstraction now has two layers instead of one
   single-queue model: `MixingSession` (an actor owning the shared
   `AVAudioEngine` graph, exposing deck-scoped control via `DeckID`) for
   local playback, and the original `Player`/`Playable` shape kept —
   unmodified — for the Apple Music bridge, where "one stream at a time"
   is actually correct. See [architecture.md](architecture.md) for the
   concurrency reasoning (two actors can't safely share one non-`Sendable`
   `AVAudioEngine`, which is why decks are internal to `MixingSession`
   rather than actors in their own right).
2. **Done, base layer only.** `Track`, `TrackImporter`/`FileTrackImporter`
   (bookmark + `AVAsset` metadata), `LocalLibraryStore`/
   `FileLocalLibraryStore` (JSON-backed) and `AudioEngineDeck` all exist and
   compile against a real `AVAudioEngine` graph. **Not done:** the
   App/UI-side document-picker flow that actually calls `TrackImporter`
   (`UIDocumentPickerViewController` is a UI concern, deliberately left to
   the App/UI target — see [state.md](state.md)), and any SwiftUI deck/mixer
   screen.
3. **Scoped, not built.** `TrackAnalyzer` exists as a protocol with an
   `UnimplementedTrackAnalyzer` placeholder — the extension point is real,
   the DSP behind it isn't. Still the single biggest open unknown.
4. **Done.** `BuiltInQueryProvider`/`MPMediaQuery` and the still-unimplemented
   `BuiltInMusicPlayerProvider` moved into `Core/AppleMusicBridge/` verbatim
   (no functional change — deliberately, to avoid a half-finished rewrite;
   see [state.md](state.md) for the specific gap blocking
   `BuiltInMusicPlayerProvider`). MusicKit migration is still a future
   option, not required now.
5. **Done.** `project.yml` deployment target is now iOS 26 (was iOS 14).

See [architecture.md](architecture.md) for how this reshapes the existing
`Provider`/`UseCase`/`Presenter` layers, and [state.md](state.md) for exactly
what's stubbed vs. real today.
