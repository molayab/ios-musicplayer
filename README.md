# MusicPlayerUI Framework
### About this repository
Here you can found all the UI related components used in MusicPlayerApp for iOS (see <<link TBA>>).

![Interface Overview](/docs/resources/musicplayer-ui-overview.gif)

## Components
All components are written for SwiftUI. 

**Public Components**
 1. GridStackView - ??
 2. CardView
 3. HomeSectionView
 4. NavigationHeaderView
 5. SheetView - ??
 6. ProgressBarView
 7. MiniPlayerView
 8. BluredView - ??
 9. SearchBarView
 10. CustomSheetView - ??

**Internal Components**
 1. GridStackView - TBD
 2. SheetView - TBD
 3. BluredView - TBD
 4. CustomSheetView - TBD

For more information, check documentation in *docs/components/ *TBA*

## How to build?
This project avoids commit .xcodeproj changes in order to avoid conflicts. In order to build this, you will need first to generate the xcode project's file. Simply run the following command: 

```bash
$ xcodegen generate
```

Ref. [https://github.com/yonaskolb/XcodeGen]