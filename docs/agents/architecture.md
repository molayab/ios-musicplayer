# Architecture overview

## Targets (defined in [project.yml](../../project.yml), XcodeGen)

No `.xcodeproj` is committed — it's regenerated from `project.yml`:

```bash
xcodegen generate
```

| Target | Type | Sources | Depends on |
|---|---|---|---|
| `Core` | framework | `Core/` | — |
| `UI` | framework | `UI/` | — |
| `App` | application | `App/` | `Core`, `UI` |
| `CoreTests` | unit test bundle | `Tests/CoreTests` | `Core` |
| `AppTests` | unit test bundle | `Tests/AppTests` | `App` |

iOS 14 minimum deployment target (worth revisiting per
[viability.md](viability.md)), Swift 6 language mode (Xcode 26 / Swift 6.2
toolchain — see [conventions.md](conventions.md#swift-6-concurrency) for what
that means day to day). `UI` and `Core` are `BUILD_LIBRARY_FOR_DISTRIBUTION`
frameworks in Release; `App` deliberately isn't (see conventions.md).

## Core: the playback/library abstraction

Defined across `Core/Playable.swift`, `Core/Player.swift`, `Core/Query.swift`,
`Core/TrackInfo.swift`, `Core/PlayerController.swift`:

- **`Playable`** — one playing/pausable/stoppable item + its `TrackInfo`.
- **`Player`** — a queue-oriented transport: `setQueue`, `skipNext/Previous`,
  a single `nowPlaying`. `PlayerController` is the concrete façade apps talk
  to; it holds a swappable `Player` (`register(playerProvider:)`).
- **`Query`** — a filterable source of `TrackInfo` items/collections
  (`addFilter`, `QueryFilter` on title/artist/playCount).
- Concrete providers live in `Core/Providers/`:
  - `BuiltInQueryProvider` — wraps `MPMediaQuery` (MediaPlayer framework —
    the system-synced Music library, **not** arbitrary local files).
  - `BuiltInMusicPlayerProvider` — **empty stub**, no `Player` conformance
    implemented yet.

This shape (queue + single now-playing) matches a Music.app-style player.
It does **not** support multi-deck simultaneous playback — see
[viability.md](viability.md) for why that matters for the DJ pivot and how
this layer likely needs to change.

## App: custom light "clean architecture"

Defined in `App/Foundations/Arch.swift`. Four layers, each with a matching
`*Dependencies`/`*Injector` protocol pair, wired through Swift protocol
extensions rather than a DI container:

```
Scene (SwiftUI View + ViewModel)
   -> Presenter (business/UI logic, weak ref back to scene)
       -> UseCase (single-purpose application logic)
           -> Provider (data access, wraps Core)
```

- **`Provider`** — wraps `Core` types for app use (e.g.
  `App/Providers/CoreLibraryProvider.swift` turns `Core.Query` results into
  `App/Entities/MediaItem.swift`).
- **`UseCase`** — one method (`run(completion:)`), one job. See
  `App/UseCases/{GetSongsUseCase,GetRecentlyAddedAlbumsUseCase,GetRediscoverAlbumsUseCase}.swift`.
- **`Presenter`** — conforms to `Presenter`, holds a `weak var scene`, exposes
  a `*Protocol` the Scene's ViewModel conforms to. `register(scene:)` does a
  forced cast + `fatalError` if the wrong scene type is passed — intentional
  fail-fast, not a bug.
- **`Scene`** — a SwiftUI `View` + an `ObservableObject` `ViewModel` that
  registers itself with the presenter on init and republishes presenter
  callbacks via `@Published` properties.

Dependency injection is **static, protocol-based**, not a container:

```swift
// declare what a layer needs:
struct Dependencies: PresenterDependencies {
    var getSongsUseCase: GetSongsUseCaseProtocol = inject()
}

// satisfy it by extending the matching *Injector protocol:
extension UseCaseInjector {
    static func inject() -> GetSongsUseCaseProtocol {
        GetSongsUseCase(dependencies: .init())
    }
}
```

`App/Foundations/DependencyInjector.swift` is a separate, narrower piece: a
thread-safe keyed singleton cache (`injectOnce(for:singleton:)`), meant only
for genuinely shared/expensive instances — not the default injection path.
Current `Key` enum only has a placeholder `.test` case; nothing production
uses it yet.

Worked example end to end: `LibraryView` → `LibraryPresenter` →
`GetSongsUseCase` → `CoreLibraryProvider` → `Core.BuiltInQueryProvider`
(`App/Scenes/Library/*`, `App/UseCases/GetSongsUseCase.swift`,
`App/Providers/CoreLibraryProvider.swift`).

## UI: component library

Public SwiftUI components consumed by `App` — see
[ui-standards.md](ui-standards.md) for the catalog and conventions.

## Current scenes (App/Scenes)

- `Home` — top-level nav container: mini menu + library entry point +
  rediscover collection.
- `Library` — list of songs (currently wired to `GetSongsUseCase` but the
  view itself doesn't call it yet — see [state.md](state.md)).
- `MiniMenu` — horizontal grid menu, presenter currently returns static data.
- `Player` — `PlayerContainerView` wraps all content and reserves space for a
  mini-player bar; the bar itself is a `// TODO` placeholder `Rectangle()`.
- `RediscoverItemCollection` — surfaces albums via
  `GetRediscoverAlbumsUseCase`'s skip-count/last-played heuristic.

None of these are backed by real playback yet (`BuiltInMusicPlayerProvider`
is a stub), so today the app can at most enumerate the system Music library —
it can't play anything.
