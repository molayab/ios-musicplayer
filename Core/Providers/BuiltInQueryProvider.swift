//

import MediaPlayer

public final class BuiltInQueryProvider: Query {
    private var mediaQuery: MPMediaQuery!
    
    public var items: [TrackInfo]? {
        return mediaQuery.items?.map { (mediaItem) -> TrackInfo in
            return getTrackInfo(usingMediaItem: mediaItem)
        }
    }
    
    public var collections: [TrackInfo]? {
        return mediaQuery.collections?.compactMap { (mediaItem) -> TrackInfo? in
            guard let item = mediaItem.representativeItem  else {
                return nil
            }
            
            return getTrackInfo(usingMediaItem: item)
        }
    }
    
    public func addFilter(_ filter: QueryFilter) {
        var comparisonType: MPMediaPredicateComparison?
        if let filter = filter.comparisonType {
            switch filter {
            case .contains:
                comparisonType = .contains
            case .equals:
                comparisonType = .equalTo
            }
        }
        
        if let comparisonType = comparisonType {
            let predicate = MPMediaPropertyPredicate(value: filter.value,
                                                     forProperty: filter.propertyContext,
                                                     comparisonType: comparisonType)
            mediaQuery.addFilterPredicate(predicate)
        } else {
            let predicate = MPMediaPropertyPredicate(value: filter.value,
                                                     forProperty: filter.propertyContext)
            mediaQuery.addFilterPredicate(predicate)
        }
    }
    
    public func removeFilter(_ filter: QueryFilter) { }
    
    public init(initialSet: QueryFilter.InitialSet) {
        switch initialSet {
        case .songs:
            getAllSongs()
        case .albums:
            getAllAlbums()
        }
    }
    
    private func getAllSongs() {
        mediaQuery = MPMediaQuery.songs()
    }
    
    private func getAllAlbums() {
        mediaQuery = MPMediaQuery.albums()
        mediaQuery.groupingType = .album
    }
    
    private func getTrackInfo(usingMediaItem mediaItem: MPMediaItem) -> TrackInfo {
        return .init(title: mediaItem.title ?? "",
                     artist: mediaItem.artist,
                     album: mediaItem.albumTitle,
                     albumArtist: mediaItem.albumArtist,
                     genre: mediaItem.genre,
                     isLoved: true,
                     artwork: { return mediaItem.artwork?.image(at: .init(width: 150, height: 150)) },
                     skipCount: mediaItem.skipCount,
                     lastPlayedDate: mediaItem.lastPlayedDate,
                     dateAdded: mediaItem.dateAdded)
    }
}

extension QueryFilter {
    var propertyContext: String {
        switch property {
        case .title:
            return MPMediaItemPropertyTitle
        case .artist:
            return MPMediaItemPropertyArtist
        case .playCount:
            return MPMediaItemPropertyPlayCount
        }
    }
}
