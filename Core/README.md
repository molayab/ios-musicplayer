#  Core Engine

Core has two layers, split by what they can and can't do with audio (see
[docs/agents/viability.md](../docs/agents/viability.md) for the full
reasoning, or [docs/architecture-diagrams.md](../docs/architecture-diagrams.md)
for the same thing as diagrams):

## Local DJ engine (primary)

The user's own imported files, fully under app control via `AVAudioEngine`
— raw PCM access, so this is where cue points, tempo/pitch, and
simultaneous multi-deck playback live.

- `Track` *(struct)* — a locally-imported file: metadata plus a
  security-scoped bookmark.
- `MixingSession` *(actor)* — owns the shared `AVAudioEngine` graph and both
  decks, exposed as `DeckID`-scoped operations (`.a` / `.b`) rather than as
  separate deck objects, because the engine and its decks are one
  non-Sendable graph and have to live in a single actor isolation domain.
- `DeckState` / `DeckID` / `CuePoint` *(value types)* — the public vocabulary
  for `MixingSession`'s deck-scoped API.
- `LocalLibraryStore` *(protocol)*, `FileLocalLibraryStore` *(actor)* — a
  minimal JSON-backed index of imported tracks.
- `TrackImporter` *(protocol)*, `FileTrackImporter` *(actor)* — turns picked
  file URLs into `Track`s (bookmark + best-effort `AVAsset` metadata).
- `TrackAnalyzer` *(protocol)*, `UnimplementedTrackAnalyzer` *(struct)* — the
  BPM/musical-key extension point. Deliberately unimplemented: there's no
  first-party API for this and real DSP beat-detection is its own project;
  see viability.md before picking this up.

## Apple Music bridge (secondary — `AppleMusicBridge/`)

`Playable` / `Query` / `Player` / `TrackInfo` / `PlayerController`, and their
`MPMediaQuery`-backed implementations. This is the original 2020 design,
kept but demoted: a single system-level playback stream for browsing/
listening to the user's Apple Music library, **not** part of the deck/mixer
surface. Apple Music catalog tracks are DRM-protected, so a single
black-box stream really is the ceiling here — the single-queue shape that
was wrong for DJ decks is the right shape for this.

`BuiltInMusicPlayerProvider` is still an unimplemented stub — see
[docs/agents/state.md](../docs/agents/state.md) for what's actually needed to
finish it (it's more than just wrapping `MPMusicPlayerController`: `Query`
doesn't currently retain enough information to build a playback queue from
its results).

## Contributing

- Local DJ engine changes: keep `AVAudioEngine` state inside `MixingSession`'s
  single actor isolation domain — don't reintroduce a second actor sharing
  the same engine (that's exactly the Swift 6 data-race trap this design
  avoids; see the file header comments in `AudioEngine/` for the reasoning).
- Apple Music bridge changes: register a new provider by conforming to
  `Player`, following the existing `BuiltInQueryProvider`/
  `BuiltInMusicPlayerProvider` pattern in `AppleMusicBridge/Providers/`.
