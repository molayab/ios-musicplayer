# MusicPlayerUI Framework
### About this repository
Here you can found all the UI related components used in MusicPlayerApp for iOS (see <<link TBA>>).
> * MusicPlayerApp is a WIP project that creates a simplier iOS Music-App using MusicKit and AppleMusic APIs. Based on a single view UI that tries to make more easier naviage throght you music library no matters it is based on Apple cloud services or just the standard file-based library. More information TBA.

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