# Purpose

## Original vision (2020)

OpenMusicPlayer started as a minimalist, single-view third-party alternative
to Apple's Music app — flatter design, simpler UX, built on the then-new
SwiftUI app lifecycle (iOS 14). See the root [README.md](../../README.md) for
the original pitch.

## Current direction (this revival)

The project is being refocused as **a local-file music player built for DJs**
— a personal DJ library tool, not a Music.app clone:

- **Primary: local files, fully under the user's control.** Import your own
  tracks (MP3/AAC/ALAC/AIFF/WAV/FLAC), organize them as a DJ library, and get
  DJ-relevant playback: cue points, waveforms, looping, crossfading, BPM-aware
  mixing. The user's own files, not a synced subset of some other library.
- **Secondary: optional Apple Music bridge.** If the user has an active Apple
  Music subscription, let them browse and play their Apple Music library
  alongside their local one — but only as a convenience "listen" surface.
  Apple Music (DRM-protected) tracks are explicitly **out of scope** for
  mixing/cues/waveforms/BPM — that's a platform limitation, not a missing
  feature. See [viability.md](viability.md) for why.

## Non-goals

- Not trying to be a full Music.app replacement for casual listening as the
  primary use case — that's the legacy framing, kept only insofar as the
  Apple Music bridge serves it.
- Not attempting to circumvent Apple Music DRM in any way.
- Not (yet) a multi-provider abstraction for other streaming services
  (Spotify, etc.) — see `Core/README.md`'s original "one provider at a time"
  note; the DJ pivot doesn't currently require solving that.

## Audience

Primarily the maintainer's own use case: a mobile DJ library/prep tool. Design
and prioritize for that user before general-audience polish.
