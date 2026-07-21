# Current state (as of this revival)

Snapshot at 2026-07-21. Re-verify against `git log` / the actual files before
trusting specifics — this rots fast.

## Dormancy

Last commits (2026-01-30) were an architecture rework
(`a013de2` "Arch definition" through `685e995`), on top of an otherwise
untouched 2020 SwiftUI-lifecycle skeleton. No open branches besides `master`.

## What's real vs. stubbed

| Area | Status |
|---|---|
| `Core` protocols (`Player`, `Query`, `Playable`, `TrackInfo`) | Defined, stable shape, but designed around single-stream queue playback (see [viability.md](viability.md)). |
| `BuiltInQueryProvider` | Implemented — wraps `MPMediaQuery` (system Music library, not arbitrary local files). |
| `BuiltInMusicPlayerProvider` | **Empty stub.** `Player` conformance is commented out. No actual playback exists in the app today. |
| `App` Provider/UseCase layer | Implemented and wired for read-only queries (`GetSongsUseCase`, `GetRecentlyAddedAlbumsUseCase`, `GetRediscoverAlbumsUseCase`). |
| `LibraryView` | Renders a `ViewModel.items` list, but nothing currently calls `GetSongsUseCase` to populate it — the presenter/use-case wiring for this scene isn't finished. |
| `HomeViewPresenter` | `fetchStarredItems()` pushes hardcoded `"Test"/"Test"/"Test"` data — placeholder, not real. |
| `MiniMenuPresenter` | Hardcoded static menu items (`Playlists`, `Artists`, `Albums`, ...) — no real data source. |
| `PlayerContainerView` | Reserves layout space for a mini-player bar; the bar itself is a literal `Rectangle() // TODO: Set the player view`. |
| Tests (`Tests/AppTests`, `Tests/CoreTests`) | Empty — only `.gitkeep` files. No test target has a single test yet. |
| `UI/Legacy/Components/*` | Not referenced by any current Scene. Pre-refactor leftovers. |
| `Theme.Fonts` | Empty struct; bundled `Oswald`/`Roboto` `.ttf` files aren't registered anywhere. |
| Apple Music entitlement | `NSAppleMusicUsageDescription` present in `App/Info.plist`; no MusicKit capability configured yet. |
| Local file import (Files/document picker) | **Does not exist yet.** Nothing in the repo reads arbitrary files — this is entirely new work for the DJ pivot. |

## Practical implication for agents

Before implementing a feature request, check whether it assumes playback,
local file import, or persisted library state already work — none of them
do yet. "Wire the UI to real data" tasks in this repo usually mean *building*
the missing provider, not just calling an existing one.
