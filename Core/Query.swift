//
//  Query.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

public protocol Query {
    static func allSongs() -> Self
    static func allArtits() -> Self
    static func allAlbums() -> Self
    static func allPlaylists() -> Self
    static func allComposers() -> Self
    static func allGenres() -> Self
    static func allCompilations() -> Self

    var groupType: Any { get set }

    func addFilter(_ filter: QueryFilter)
    func removeFilter(_ filter: QueryFilter)
}

public struct QueryFilter {
    // TODO
}
