//
//  BuiltInMusicPlayerProvider.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

import Foundation

/// Apple Music bridge — see `../Player.swift`. Still unimplemented (tracked
/// in `docs/agents/state.md`): a real implementation needs
/// `MPMusicPlayerController` plus a way to map `Query`'s `TrackInfo` results
/// back to the underlying `MPMediaItem`/persistent ID, which `Query` doesn't
/// currently retain — that gap needs closing first, not glossed over here.
public final class BuiltInMusicPlayerProvider/*: Player */ {
}
