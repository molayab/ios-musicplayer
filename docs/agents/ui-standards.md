# UI standards

## Design principles (from the original README, still the baseline)

- Minimalist, "flatten" design.
- Single-view-first navigation — avoid deep hierarchies where a sheet/overlay
  will do (`PlayerContainerView` wrapping all content instead of pushing a
  separate player screen is the concrete expression of this).
- "Dev-art first": functional placeholder art is fine mid-development; final
  visual polish is a later pass, not a blocker.
- Icons: [Material Icons](https://material.io/resources/icons/?style=round)
  (Apache 2.0). **Only non-copyrighted assets** — this was a hard rule in the
  original README and should stay one.

## Where UI code lives

- `UI/` target — public, reusable, SwiftUI-only components consumed by
  `App`. Anything here must have a SwiftUI `PreviewProvider`.
- `UI/Legacy/Components/` — pre-refactor components (`BluredView`,
  `CardView`, `CustomSheetView`, `HomeSectionView`, `MiniPlayerView`,
  `NavigationHeaderView`, `ProgressBarView`, `SearchBarView`, `SheetView`).
  **Not currently used by any Scene** — treat as reference/salvage material,
  not the current standard. Audit before reusing; don't add to this folder.
- `App/Scenes/*/*.swift` — screen-specific composition, not reusable outside
  the app target.

## Component catalog (`UI/Components`)

| Component | Purpose |
|---|---|
| `PlayableItemView` | Core "track/album card": artwork + title + optional subtitle, falls back to a bundled default cover art. |
| `GridStackView` | Generic row/column grid layout builder used by `MiniMenuView`. |
| `GroupView` | Grouping/section container. |
| `MiniMenuItemView` | Single cell inside the horizontal mini menu. |
| `TitleView` | Section title text style. |

Full narrative catalog with reference screenshots:
[UI/Components/README.md](../../UI/Components/README.md).

## Theming

`UI/Theme.swift` — a singleton (`Theme.default`) exposing:

- `Colors` enum (`CaseIterable`) resolving to named colors in
  `UI/Resources/Colors.xcassets` via `UIColor(named:in:)`, falling back to
  `.cyan` if a name is missing (deliberately jarring fallback — treat cyan
  showing up anywhere as a missing color asset, not an intentional style).
  Current cases: `backgroundPrimaryColor`, `backgroundSecundaryColor`,
  `redTintColor`, `textPrimaryColor`, `textSecundaryColor`. Note the existing
  spelling `SecundaryColor` (not `Secondary`) — match it exactly when adding
  related cases, don't "fix" the typo without a deliberate rename pass across
  both the enum and the `.xcassets` entries.
- `Fonts` struct — currently **empty**. Font files (`Oswald-*.ttf`,
  `Roboto-*.ttf`) already exist under `UI/Resources/Fonts/` but aren't wired
  up anywhere (not in `Info.plist` `UIAppFonts`, not referenced by `Theme`).
  Treat custom typography as unimplemented, not broken.

## Conventions when adding UI

- Public components go in `UI/Components/`, are `public struct ... : View`,
  and use `Theme.default` for color — don't hardcode `Color(...)` literals
  for anything that should themeable.
- Every component needs a `_Previews: PreviewProvider`.
- Scenes follow the `Scene`/`Presenter`/`ViewModel` pattern from
  [architecture.md](architecture.md) — don't put business logic in a View's
  `body`.
