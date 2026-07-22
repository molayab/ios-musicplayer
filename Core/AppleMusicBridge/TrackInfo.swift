//
//  TrackInfo.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

import UIKit

/// Apple Music bridge metadata — see `Player.swift`. Distinct from `Track`,
/// which describes a locally-imported file the app fully controls.
public struct TrackInfo {
    public let title: String
    public let artist: String?
    public let album: String?
    public let albumArtist: String?
    public let genre: String?
    public let isLoved: Bool
    public let artwork: (() -> UIImage?)
    public let skipCount: Int
    public let lastPlayedDate: Date?
    public let dateAdded: Date
}
