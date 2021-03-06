//

import UIKit

public struct MediaItem {
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
