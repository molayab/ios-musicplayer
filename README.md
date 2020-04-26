# OpenMusicPlayer for iOS

OpenMusicPlayer for iOS tries to simplify the way that we interact with the music on our Apple devices. It basically is a third-party alternative to the native music app. We don't want to re-invent the wheel, just make it easier and funnier to use!

OpenMusicPlayer is inspired by minimalistic design, simple UX, and flatten design patterns. Thinking in that way, the application is made following just a single view pattern, there you'll have everything you need to interact with your built-in and/or Apple Music library.

## About this repository

This repository is fully inspired by commercial alternatives to Apple's iOS music app. However, I fully agree with the OpenSource initiative, so I decided to start this small project. If you would like to contribute with me, with us. Do not doubt to share your contribution, we are glad to review it. However, please read and validate that your contribution is following our community rules and the code follows our style. Read **Contribute** section for more info.

Here you'll find all the code and documentation related to OpenMusicPlayer for iOS.

### Project's structure

You'll see some folders in the project, we tried to simplify and decouple the overall project's architecture splitting it into 3 different targets: UI components, music's core, and application.

 1. **MusicPlayerCore & Tests**: This framework contains the music core and its definitions and dependencies. It defines an abstract way using protocol-oriented swift to communicate to multimedia (music) iOS' APIs (including Apple Music).
 2. **MusicPlayerUI**: This framework contains all the UI components required by the main application, all those are public and can define some internal (not-exposed) components as needed. All those components MUST be developed for SwiftUI. Create UIKit bindings as needed.
 3. **MusicPlayerApp**: This is the final application, that one that will be delivered to the AppStore. It requires MusicPlayerCore and MusicPlayerUI and orchestrates UI & CORE communication.

### Warning

Before continuing we should advise that some MusicKit APIs are buggy and unstable, Apple should fix those as soon as possible, but we don't have control over the backlog, so be careful contributing.

### In-dev UI "tentative" preview

![Interface Overview](/docs/resources/musicplayer-ui-overview.gif)

## Components

All components MUST be written for SwiftUI.

### Overall Design

TBD

### Public Components

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

### Internal Components

 1. GridStackView - TBD
 2. SheetView - TBD
 3. BluredView - TBD
 4. CustomSheetView - TBD

For more information, check documentation in *docs/components/*

## How to build

This project avoids commit .xcodeproj changes in order to avoid conflicts. In order to build this, you will need first to generate the xcode project's file. Simply run the following command:

```bash
xcodegen generate
```

Ref. [https://github.com/yonaskolb/XcodeGen]
