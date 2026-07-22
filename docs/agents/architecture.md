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

iOS 26 minimum deployment target, Swift 6 language mode (Xcode 26 / Swift 6.2
toolchain — see [conventions.md](conventions.md#swift-6-concurrency) for what
that means day to day). `UI` and `Core` are `BUILD_LIBRARY_FOR_DISTRIBUTION`
frameworks in Release; `App` deliberately isn't (see conventions.md).

## Core: two layers, split by what they can do with audio

`Core` has two independent halves — see
[Core/README.md](../../Core/README.md) for the file-level catalog,
[viability.md](viability.md) for the full reasoning behind the split, and
[architecture-diagrams.md](../architecture-diagrams.md) for the same thing
as Mermaid diagrams (module map, the actor-ownership design, import/mixing
sequence flows).

### Local DJ engine (primary — `Core/`, `Core/AudioEngine/`, `Core/Library/`, `Core/Analysis/`)

- **`MixingSession`** *(actor)* — owns the shared `AVAudioEngine` graph and
  both decks, exposing control through `DeckID`-scoped methods
  (`load(_:into:)`, `play(_:)`, `setCrossfade(_:)`, ...) rather than handing
  out separate deck objects.
  **Why:** two decks sharing one `AVAudioEngine` — which is not
  `Sendable` — cannot safely be two independent actors under Swift 6; the
  compiler correctly rejects passing the shared engine into a second actor's
  isolated storage ("sending risks causing data races"). Making
  `MixingSession` the *only* actor in the graph, with `AudioEngineDeck` as
  an internal (non-actor, non-public) implementation class it exclusively
  owns, keeps the whole graph in one isolation domain. Don't reintroduce a
  second actor here without solving that sharing problem first.
- **`Track`** *(struct)* — a locally-imported file: metadata + a
  security-scoped bookmark (`resolveSecurityScopedURL()`), not a live `URL`
  — sandbox/iCloud paths can move between launches.
- **`LocalLibraryStore`** (protocol) / **`FileLocalLibraryStore`** (actor) —
  minimal JSON-file persistence for imported tracks. No SQLite/SwiftData;
  revisit only if real query/filter needs show up.
- **`TrackImporter`** (protocol) / **`FileTrackImporter`** (actor) — turns
  picked file `URL`s into `Track`s (bookmark + best-effort `AVAsset`
  metadata). The picker UI itself (`UIDocumentPickerViewController`) is an
  App/UI concern and isn't wired up yet — see [state.md](state.md).
- **`TrackAnalyzer`** (protocol) / **`UnimplementedTrackAnalyzer`** — the
  BPM/musical-key extension point, deliberately left unimplemented (no
  first-party API, real DSP work; see viability.md).

### Apple Music bridge (secondary — `Core/AppleMusicBridge/`)

The original 2020 design, relocated and demoted but otherwise **unchanged**:
`Playable`, `Player`, `PlayerController`, `Query`/`QueryFilter`, `TrackInfo`,
plus `Providers/BuiltInQueryProvider` (wraps `MPMediaQuery`) and
`Providers/BuiltInMusicPlayerProvider` (still an empty stub).

- **`Player`** — a queue-oriented transport: `setQueue`, `skipNext/Previous`,
  a single `nowPlaying`. This single-queue shape was wrong as a model for DJ
  decks, but it's the *right* shape here: Apple Music catalog tracks are
  DRM-protected, so a single system-level black-box stream really is the
  ceiling for this bridge. `PlayerController` is the concrete façade apps
  talk to; it holds a swappable `Player` (`register(playerProvider:)`).
- **`Query`** — a filterable source of `TrackInfo` items/collections from
  the system-synced Music library — **not** arbitrary local files (that's
  `LocalLibraryStore`'s job now).
- `BuiltInMusicPlayerProvider` staying a stub is a known gap, not an
  oversight of this reorganization — see [state.md](state.md) for exactly
  what's missing before it can be implemented.

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
