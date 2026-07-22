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

## Swift 6 concurrency

The project builds under **Swift 6 language mode** (`SWIFT_VERSION: "6"` in
`project.yml`, requires Xcode 26 / Swift 6.2+ toolchain), with
`SWIFT_APPROACHABLE_CONCURRENCY: YES` (strict concurrency checking is
inherent to language mode 6, not a separate opt-in).
A few consequences to know before touching build settings or writing
concurrent code:

- `App` and `UI` set `SWIFT_DEFAULT_ACTOR_ISOLATION: MainActor` — types in
  those targets are implicitly `@MainActor` unless marked `nonisolated`.
  This matches those targets being UI-bound (SwiftUI views, presenters that
  talk to the main-actor scene). `Core` has **no** default isolation
  override — it's meant to stay concurrency-agnostic/background-safe, so
  don't add one there without a specific reason.
- If a type in `App`/`UI` genuinely isn't UI-related (e.g.
  `App/Foundations/DependencyInjector.swift`'s `Key` enum, which must be
  usable from a background `DispatchQueue`), mark it explicitly
  `nonisolated` rather than fighting the target-wide default.
- `DependencyInjector` predates Swift concurrency and synchronizes its
  static cache manually with a concurrent `DispatchQueue`
  (`.sync`/`.async(flags: .barrier)`). That's still correct at runtime, but
  the compiler can't verify it, hence `private nonisolated(unsafe) static var
  instances`. Don't remove the `nonisolated(unsafe)` without replacing the
  manual synchronization with something the compiler can check (e.g. an
  actor) — and note an actor would make `injectOnce` `async`, which breaks
  its documented use inside non-async default-parameter initializers
  (`var x: XProtocol = inject()`), so that's a real design trade-off, not a
  drop-in swap.
- `BUILD_LIBRARY_FOR_DISTRIBUTION: YES` (module stability) is scoped to the
  `Core` and `UI` framework targets' Release config only, not applied
  project-wide. Applying it to `App` breaks Release builds: the app module
  is named `App`, which collides with `SwiftUI.App` when the compiler
  verifies the generated `.swiftinterface`, and application targets don't
  need module stability anyway.

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
