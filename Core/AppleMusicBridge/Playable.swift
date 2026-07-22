//
//  Playable.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

/// Apple Music bridge item — see `Player.swift`. No PCM/waveform access is
/// possible for these (DRM), so this stays a coarse play/pause/stop surface.
public protocol Playable {
    /// Returns the current playable state, playing, paused or stopped.
    var state: PlayableState { get }
    /// Returns the context of the playable item a.k.a metadata.
    var context: TrackInfo { get }

    func play()
    func pause()
    func stop()
}

public enum PlayableState {
    case playing
    case paused
    case stopped
}
