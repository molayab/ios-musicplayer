//
//  TrackImporter.swift
//  Core
//
//  Turns file URLs the user picked (Files / document picker / drag-and-drop
//  — the actual picker UI is an App/UI concern) into Tracks: a
//  security-scoped bookmark plus best-effort metadata read via AVAsset.
//  This is the "import my own files" subsystem viability.md calls out as
//  net-new — none of it existed before this pivot.
//

import AVFoundation

public protocol TrackImporter: Sendable {
    /// One `Result` per input URL, in order, so a partial failure (one
    /// unreadable file in a batch) doesn't lose the rest of the import.
    func importTracks(from urls: [URL]) async -> [Result<Track, Error>]
}

public enum TrackImportError: Error, Sendable {
    case accessDenied
}

public actor FileTrackImporter: TrackImporter {
    public init() {}

    public func importTracks(from urls: [URL]) async -> [Result<Track, Error>] {
        var results: [Result<Track, Error>] = []
        for url in urls {
            do {
                results.append(.success(try await importTrack(from: url)))
            } catch {
                results.append(.failure(error))
            }
        }
        return results
    }

    private func importTrack(from url: URL) async throws -> Track {
        guard url.startAccessingSecurityScopedResource() else {
            throw TrackImportError.accessDenied
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let bookmarkData = try url.bookmarkData()
        let asset = AVURLAsset(url: url)
        let duration = try? await asset.load(.duration)
        let commonMetadata = (try? await asset.load(.commonMetadata)) ?? []

        var title = url.deletingPathExtension().lastPathComponent
        var artist: String?
        var album: String?

        for item in commonMetadata {
            guard let key = item.commonKey else { continue }
            let value = try? await item.load(.stringValue)
            switch key {
            case .commonKeyTitle: if let value { title = value }
            case .commonKeyArtist: artist = value
            case .commonKeyAlbumName: album = value
            default: break
            }
        }

        return Track(title: title,
                     artist: artist,
                     album: album,
                     duration: (duration?.isNumeric == true) ? duration?.seconds : nil,
                     dateAdded: Date(),
                     bookmarkData: bookmarkData)
    }
}
