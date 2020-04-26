//
//  Playable.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

public protocol Playable {
    var state: PlayableState { get }

    func play()
    func pause()
    func stop()
}

public enum PlayableState {
    case playing
    case paused
    case stopped
}
