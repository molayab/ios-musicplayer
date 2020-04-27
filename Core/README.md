#  Core Engine

In order to abstract the deeper complexity in the MusicKit framework, and looking for a protocol-oriented and SOLID-like way to define our core engine. We created the following Core's public interface.

## Public Interface

### Playable ***(protocol)***
### Query ***(protocol)***
### Player ***(protocol)***
### TrackInfo ***(struct)***
### PlayerController ***(class)***

## Overall Architecture

TBA

## Modular Capabilities

The overall Core's architecture was designed thinking in the possibility of exchange the libraries and player data source in order to be able to handle different providers rather than Apple Music. However, for the MVP we ONLY support built-in player and library capabilities included in MusicKit by Apple. Looking for a further provider expansion.

### Limitations

Due to Apple's MusicKit limitations, you can only have ONE provider working at the same time. It means that via the configuration you will have to choose if, for example, use Apple Music, or Spotify and go on. Making LIKE-IMPOSSIBLE creates a shared queue with mixed content. However, we will perform further investigations.

### Contributing

If you are looking to contribute with the Core Engine, please follow our code style and ensure you are following the style before raising any MR, thanks!. Feel free to create a folder into _Providers/_ with all your needed stuff, remember that you will have to define just one public adapter of our **Player protocol** that will be registered on the Controller for further use. Check the build-in implementation for detailed code-base information.
