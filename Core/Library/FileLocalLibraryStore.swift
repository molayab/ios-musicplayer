//
//  FileLocalLibraryStore.swift
//  Core
//
//  Minimal JSON-file-backed LocalLibraryStore. Deliberately simple (no
//  SQLite/SwiftData) — the library is a flat array of Track, and there's no
//  query/filter requirement yet that would justify a real database. Revisit
//  once library size or filtering needs (per-playlist, per-crate, etc.)
//  actually show up.
//

import Foundation

public actor FileLocalLibraryStore: LocalLibraryStore {
    private let fileURL: URL
    private var cache: [Track]?

    public init(fileURL: URL = FileLocalLibraryStore.defaultStoreURL()) {
        self.fileURL = fileURL
    }

    public static func defaultStoreURL() -> URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("LocalLibrary.json")
    }

    public func allTracks() async throws -> [Track] {
        try loadIfNeeded()
        return cache ?? []
    }

    public func add(_ tracks: [Track]) async throws {
        try loadIfNeeded()
        cache = (cache ?? []) + tracks
        try persist()
    }

    public func remove(_ trackID: Track.ID) async throws {
        try loadIfNeeded()
        cache?.removeAll { $0.id == trackID }
        try persist()
    }

    public func update(_ track: Track) async throws {
        try loadIfNeeded()
        guard let index = cache?.firstIndex(where: { $0.id == track.id }) else { return }
        cache?[index] = track
        try persist()
    }

    private func loadIfNeeded() throws {
        guard cache == nil else { return }
        guard let data = try? Data(contentsOf: fileURL) else {
            cache = []
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        cache = try decoder.decode([Track].self, from: data)
    }

    private func persist() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(cache ?? [])
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                 withIntermediateDirectories: true)
        try data.write(to: fileURL, options: .atomic)
    }
}
