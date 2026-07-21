# Conventions

## Build

No `.xcodeproj` is committed on purpose (avoids merge conflicts). Regenerate
it after any `project.yml` or file-layout change:

```bash
xcodegen generate
```

([XcodeGen](https://github.com/yonaskolb/XcodeGen), pinned to
`minimumXcodeGenVersion: 2.11.0` in `project.yml`.) Then build/run
`OpenMusicPlayer.xcodeproj` normally (Xcode or `xcodebuild`).

## Tests

`CoreTests` and `AppTests` targets exist and are wired in `project.yml`, but
contain no tests yet (just `.gitkeep`). When adding logic to `Core` or
`App`'s UseCase/Presenter layers, add the corresponding XCTest — there's no
existing test to pattern-match against yet, so keep it simple (plain
`XCTestCase`, no test framework preference established).

## Code style observed in the repo

- Two file-header styles coexist: older files carry a full Xcode header
  comment block (`//  File.swift`, `//  Target`, `//  Created by...`); newer
  files (post arch-rework) just start with a bare `//`. Match whichever
  style the surrounding file/folder already uses; don't mix within one file.
- Protocol-oriented throughout: almost every concrete type pairs with a
  `*Protocol` it publicly exposes (`GetSongsUseCaseProtocol`,
  `LibraryPresenterProtocol`, etc.) — keep that pairing when adding
  UseCases/Presenters/Providers, per [architecture.md](architecture.md).
  Scenes are the exception: `View`/`ViewModel` structs are concrete, only the
  `*ViewProtocol` the ViewModel conforms to is abstracted.
- `// MARK: -` sections are used to separate a type's core body from its
  `ViewModel`/preview extensions in Scene files — follow the existing
  pattern in `App/Scenes/**/*View.swift` rather than inventing a new layout.
- Injection is via static `inject()`/`injectXxx()` on the relevant
  `*Injector` protocol extension, not a DI container or property wrapper —
  see [architecture.md](architecture.md) for the full pattern before adding
  a new Provider/UseCase/Presenter.

## Scope discipline

This is a personal-scale revival, not a team project. Prefer the smallest
change that moves the DJ-pivot goal forward (see
[viability.md](viability.md)) over speculative abstraction — the repo
already has one over-abstracted layer (`Core`'s single-queue `Player`) that
will need reworking specifically because it was built more generically than
the (then-unstated) actual requirement needed.
