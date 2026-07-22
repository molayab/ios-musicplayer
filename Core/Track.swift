//
//  Track.swift
//  Core
//
//  A locally-imported audio file the app fully controls (as opposed to
//  `TrackInfo`, which describes an Apple Music bridge item the app can only
//  ever play back through a system black box). See docs/agents/viability.md.
//

import Foundation

public struct Track: Identifiable, Hashable, Sendable, Codable {
    public let id: UUID
    public var title: String
    public var artist: String?
    public var album: String?
    public var albumArtist: String?
    public var genre: String?
    public var duration: TimeInterval?
    public var bpm: Double?
    public var musicalKey: String?
    public var dateAdded: Date

    /// Security-scoped bookmark to the file on disk (sandbox-copied file or
    /// an external location such as iCloud Drive). Resolved on demand via
    /// `resolveSecurityScopedURL()` rather than kept as a live `URL`, since
    /// sandbox/iCloud paths can move between launches.
    public var bookmarkData: Data

    public init(id: UUID = UUID(),
                title: String,
                artist: String? = nil,
                album: String? = nil,
                albumArtist: String? = nil,
                genre: String? = nil,
                duration: TimeInterval? = nil,
                bpm: Double? = nil,
                musicalKey: String? = nil,
                dateAdded: Date = Date(),
                bookmarkData: Data) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.albumArtist = albumArtist
        self.genre = genre
        self.duration = duration
        self.bpm = bpm
        self.musicalKey = musicalKey
        self.dateAdded = dateAdded
        self.bookmarkData = bookmarkData
    }
}

public enum TrackError: Error, Sendable {
    case staleBookmark
    case unableToAccessSecurityScopedResource
}

extension Track {
    /// Resolves the file's location and begins security-scoped access.
    /// Callers must call `stopAccessingSecurityScopedResource()` on the
    /// returned URL when done (mirrors Foundation's own bracketing API).
    public func resolveSecurityScopedURL() throws -> URL {
        var isStale = false
        let url = try URL(resolvingBookmarkData: bookmarkData,
                          options: [],
                          relativeTo: nil,
                          bookmarkDataIsStale: &isStale)
        guard url.startAccessingSecurityScopedResource() else {
            throw TrackError.unableToAccessSecurityScopedResource
        }
        return url
    }
}
