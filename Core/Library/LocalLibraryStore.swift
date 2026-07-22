//
//  LocalLibraryStore.swift
//  Core
//
//  Persistence for the local-file library. Before this, `Query` was the only
//  "library" concept in Core, and it was a live wrapper over `MPMediaQuery`
//  with nothing to persist — local files need their own durable index of
//  imported tracks. See docs/agents/viability.md.
//

import Foundation

public protocol LocalLibraryStore: Sendable {
    func allTracks() async throws -> [Track]
    func add(_ tracks: [Track]) async throws
    func remove(_ trackID: Track.ID) async throws
    func update(_ track: Track) async throws
}
