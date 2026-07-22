//
//  Query.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

/// Apple Music bridge library query — see `Player.swift`. Browses the
/// system-synced Music library (`MPMediaQuery`), not arbitrary local files;
/// local-file browsing lives in `LocalLibraryStore`.
public protocol Query {
    var items: [TrackInfo]? { get }
    var collections: [TrackInfo]? { get }

    func addFilter(_ filter: QueryFilter)
    func removeFilter(_ filter: QueryFilter)
    
    init(initialSet: QueryFilter.InitialSet)
}

public struct QueryFilter {
    public enum Property {
        case title
        case artist
        case playCount
    }
    
    public enum ComparisonType {
        case equals
        case contains
    }
    
    public enum InitialSet {
        case songs
        case albums
    }
    
    var property: Property
    var value: Any?
    var comparisonType: ComparisonType?
    
    public init(property: Property, value: Any?, comparisonType: ComparisonType?) {
        self.comparisonType = comparisonType
        self.value = value
        self.property = property
    }
}
