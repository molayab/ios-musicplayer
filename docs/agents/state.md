# Current state (as of this revival)

Snapshot at 2026-07-21. Re-verify against `git log` / the actual files before
trusting specifics — this rots fast.

## Dormancy

Last commits (2026-01-30) were an architecture rework
(`a013de2` "Arch definition" through `685e995`), on top of an otherwise
untouched 2020 SwiftUI-lifecycle skeleton. No open branches besides `master`.

## What's real vs. stubbed

### Local DJ engine (`Core/`, `Core/AudioEngine/`, `Core/Library/`, `Core/Analysis/`)

| Area | Status |
|---|---|
| `MixingSession` / `AudioEngineDeck` | **Implemented.** Real `AVAudioEngine` graph: load/play/pause/stop/seek, tempo adjustment (`AVAudioUnitTimePitch`), per-deck gain, cue points, crossfade between two decks. Builds and links against the iOS 26 SDK; not yet exercised against a real audio file in an actual run (no automated test covers it — see Tests row below). |
| `Track` / `FileTrackImporter` | **Implemented.** Security-scoped bookmark + `AVAsset`-derived title/artist/album/duration. **Not wired to any UI** — nothing in `App`/`UI` presents a document picker or calls this yet. |
| `FileLocalLibraryStore` | **Implemented.** JSON file under Application Support. Nothing in `App` reads from or writes to it yet. |
| `TrackAnalyzer` | **Scoped, not implemented.** `UnimplementedTrackAnalyzer` always returns empty results — see [viability.md](viability.md), this needs real DSP work before any BPM/key-dependent feature (auto-sync, harmonic mixing) is possible. |
| App-side integration (Provider/UseCase/Scene wrapping the above) | **Does not exist yet.** All of the above is Core-only; there's no `App/Providers/*` wrapper, no import UI, no deck/mixer screen. |

### Apple Music bridge (`Core/AppleMusicBridge/`)

| Area | Status |
|---|---|
| `Player`, `Query`, `Playable`, `TrackInfo`, `PlayerController` | Defined, stable shape (unchanged by the re-architecture — this single-queue shape is correct for a single DRM-limited system stream, see [viability.md](viability.md)). |
| `BuiltInQueryProvider` | Implemented — wraps `MPMediaQuery` (system Music library, not arbitrary local files). |
| `BuiltInMusicPlayerProvider` | **Still an empty stub.** `Player` conformance is commented out. Implementing it needs more than wrapping `MPMusicPlayerController`: `Query` doesn't currently retain the underlying `MPMediaItem`/persistent ID, so there's no way yet to turn a `Query` result back into something `MPMusicPlayerController` can queue. That gap has to close first. |
| Apple Music entitlement | `NSAppleMusicUsageDescription` present in `App/Info.plist`; no MusicKit capability configured (still using the legacy `MediaPlayer` APIs; MusicKit migration is optional future work, not required). |

### App/UI layer

| Area | Status |
|---|---|
| `App` Provider/UseCase layer | Implemented and wired for read-only Apple Music bridge queries (`GetSongsUseCase`, `GetRecentlyAddedAlbumsUseCase`, `GetRediscoverAlbumsUseCase`). No local-DJ-engine equivalent yet. |
| `LibraryView` | Renders a `ViewModel.items` list, but nothing currently calls `GetSongsUseCase` to populate it — the presenter/use-case wiring for this scene isn't finished. |
| `HomeViewPresenter` | `fetchStarredItems()` pushes hardcoded `"Test"/"Test"/"Test"` data — placeholder, not real. |
| `MiniMenuPresenter` | Hardcoded static menu items (`Playlists`, `Artists`, `Albums`, ...) — no real data source. |
| `PlayerContainerView` | Reserves layout space for a mini-player bar; the bar itself is a literal `Rectangle() // TODO: Set the player view`. There is no deck/mixer UI at all yet. |
| Tests (`Tests/AppTests`, `Tests/CoreTests`) | Empty — only `.gitkeep` files. No test target has a single test yet, including for the new `MixingSession`/`Track`/library code. |
| `UI/Legacy/Components/*` | Not referenced by any current Scene. Pre-refactor leftovers. |
| `Theme.Fonts` | Empty struct; bundled `Oswald`/`Roboto` `.ttf` files aren't registered anywhere. |
| Local file import UI (`UIDocumentPickerViewController` / Files) | **Does not exist yet.** `TrackImporter` (Core) can turn picked URLs into `Track`s, but nothing presents a picker to get those URLs in the first place. |

## Practical implication for agents

Before implementing a feature request, check whether it assumes playback,
local file import, or persisted library state already work end-to-end —
the *Core* pieces now exist for the local DJ engine, but nothing in `App`/`UI`
calls into them yet. "Wire the UI to real data" tasks in this repo usually
mean building the App-layer Provider/UseCase/Scene wiring on top of an
already-real Core API, not building the Core API itself anymore (for the
local engine) — check this table first either way, it rots fast.
