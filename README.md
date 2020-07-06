# OpenMusicPlayer for iOS

OpenMusicPlayer for iOS tries to simplify the way that we interact with the music on our Apple devices. It basically is a third-party alternative to the native music app. We don't want to re-invent the wheel, just make it easier and funnier to use!

OpenMusicPlayer is inspired by minimalistic design, simple UX, and flatten design patterns. Thinking in that way, the application is made following just a single view pattern, there you'll have everything you need to interact with your built-in and/or Apple Music library.

###### July 2020

> This project is now targeting iOS 14 and it will use the new SwiftUI's LifeCycle. See https://medium.com/better-programming/swiftuis-new-app-lifecycle-and-replacements-for-appdelegate-and-scenedelegate-in-ios-14-c9cf4a2367a9

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

## Core Engine

Core Engine or simply Core is our abstraction of a Music player is it. It was influenced by the build-in Apple MusicLibray flow, trying to move it to a cleanest and Swifty way to define the API. The whole API is inspired by a "fluent" human-like way to express the library and player interactions.

It defines two conceps **Player/Playable** and **Queue/Query**. For more information checkout our latest Core's documentation [here](/Core/README.md).

## Components

### Overall Design

*WIP
![Home Alpha](/docs/resources/design-home-alpha.png)

We have separate UI-related documentation, the overall design is following our dev-art first approach, keeping in mind our single-view approach. Check the component's documentation [here](/UI/Components/README.md).

If you are a designer or would like to contribute with the UI/UX experience design do not doubt to create an issue with your proposal, we will review it asap. Remember to create a Merge Request (MR) with the asset change, and remember to ONLY USE NON-COPYRIGHTED ASSETS. We aren't trying to theft anyone ;)

For this project we are using:

- ***[Material Icons Set](https://material.io/resources/icons/?style=round)*** available under Apache license version 2.0.

The MVP version of the app is trying to have included the following screens:

- Home Screen
  - Floating MiniPlayer Screen
- Search Screen
- Detail Screen
- Listable Screen
- Player Screen

## How to build

This project avoids commit .xcodeproj changes in order to avoid conflicts. In order to build this, you will need first to generate the xcode project's file. Simply run the following command:

```bash
xcodegen generate
```

Ref. [https://github.com/yonaskolb/XcodeGen]
