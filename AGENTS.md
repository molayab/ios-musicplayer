# AGENTS.md

Agent-facing index for this repo. Deeper reference docs live in
[docs/agents/](docs/agents/) — read the linked doc before working in that
area; this file is intentionally just a map.

## What this project is

**OpenMusicPlayer** — an iOS music player, currently being revived and
repointed at a new goal: a **local-file music library and player built for
DJs** (import your own tracks, cue points, waveforms, BPM-aware mixing),
with an **optional, secondary Apple Music bridge** for subscribers (browse
and listen only — DRM makes Apple Music tracks unmixable, see
[viability.md](docs/agents/viability.md)). Full detail:
[purpose.md](docs/agents/purpose.md).

**The pivot's `Core` redesign is decided and partially built** — `Core` now
has a real local-file DJ engine (`MixingSession`, `Track`,
`TrackImporter`, `LocalLibraryStore`) alongside the demoted Apple Music
bridge. What's still missing is everything above `Core`: no App/UI screen
calls into any of it yet, and BPM/key analysis is an intentionally
unimplemented placeholder. Read [state.md](docs/agents/state.md) before
assuming any *feature* (not just any Core type) works.

## Reference folder

| Doc | Read it for |
|---|---|
| [docs/agents/purpose.md](docs/agents/purpose.md) | Product goal, DJ-first vs. Apple Music bridge, non-goals |
| [docs/agents/viability.md](docs/agents/viability.md) | The investigation and decision record — DRM limits, `MPMediaQuery` vs. local files, multi-deck mixing, what was actually built vs. deferred |
| [docs/agents/architecture.md](docs/agents/architecture.md) | Target layout, `Core`'s two layers, the custom Provider/UseCase/Presenter/Scene pattern, DI approach |
| [docs/architecture-diagrams.md](docs/architecture-diagrams.md) | The same `Core` architecture as Mermaid diagrams — module map, the Swift 6 actor design behind `MixingSession`, import/mixing sequence flows |
| [docs/agents/ui-standards.md](docs/agents/ui-standards.md) | Design principles, component catalog, theming, where UI code should live |
| [docs/agents/state.md](docs/agents/state.md) | What's real vs. stubbed/placeholder right now — check before building on top of something |
| [docs/agents/conventions.md](docs/agents/conventions.md) | Build/test commands, code style, injection pattern to follow, Swift 6 concurrency gotchas |

## Quick facts

- Swift / SwiftUI, 3 targets: `Core` (framework, playback/library
  abstraction), `UI` (framework, SwiftUI components), `App` (application).
- No `.xcodeproj` committed — generated from [project.yml](project.yml) via
  XcodeGen. Run `xcodegen generate` after pulling or after any file/target
  layout change.
- No package manager dependencies today (pure XcodeGen + system frameworks:
  `MediaPlayer`, `Combine`, `Foundation`).
- Tests targets exist (`Tests/CoreTests`, `Tests/AppTests`) but are empty.

```bash
xcodegen generate
```

## Before making changes

1. Check [state.md](docs/agents/state.md) — many scenes look wired but push
   hardcoded placeholder data; don't assume "the UI shows X" means "X is a
   real data path."
2. If the change touches playback, library data, or file import, read
   [viability.md](docs/agents/viability.md) first — `Core` already has two
   separate layers for this (local DJ engine vs. Apple Music bridge, see
   [architecture.md](docs/agents/architecture.md)); make sure new code lands
   in the right one instead of extending `Player`/`Query` (the Apple Music
   bridge's single-stream shape) to do something it structurally can't.
3. Follow the existing Provider → UseCase → Presenter → Scene layering and
   its static-`inject()` DI convention ([architecture.md](docs/agents/architecture.md))
   rather than introducing a new pattern.
