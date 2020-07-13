//

import Core

protocol CoreLibraryProviderProtocol {
    func allItems(completion: ([MediaItem]) -> Void)
    func allItems(usingFilters: [Core.QueryFilter]?, completion: ([MediaItem]) -> Void)
    func allCollections(usingFilters: [Core.QueryFilter]?, completion: ([MediaItem]) -> Void)
}

final class CoreLibraryProvider: CoreLibraryProviderProtocol {
    struct Dependencies {
        var query: Query
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func allItems(completion: ([MediaItem]) -> Void) {
        allItems(usingFilters: nil, completion: completion)
    }
    
    func allItems(usingFilters: [Core.QueryFilter]?, completion: ([MediaItem]) -> Void) {
        if let filters = usingFilters {
            filters.forEach { dependencies.query.addFilter($0) }
        }
        
        let songs = dependencies.query.items?.map { trackInfo -> MediaItem in
            return .init(title: trackInfo.title,
                         artist: trackInfo.artist,
                         album: trackInfo.album,
                         albumArtist: trackInfo.albumArtist,
                         genre: trackInfo.genre,
                         isLoved: trackInfo.isLoved,
                         artwork: trackInfo.artwork,
                         skipCount: trackInfo.skipCount,
                         lastPlayedDate: trackInfo.lastPlayedDate)
        }
        
        completion(songs ?? [])
    }
    
    func allCollections(usingFilters: [Core.QueryFilter]?, completion: ([MediaItem]) -> Void) {
        if let filters = usingFilters {
            filters.forEach { dependencies.query.addFilter($0) }
        }
        
        let songs = dependencies.query.collections?.map { trackInfo -> MediaItem in
            return .init(title: trackInfo.title,
                         artist: trackInfo.artist,
                         album: trackInfo.album,
                         albumArtist: trackInfo.albumArtist,
                         genre: trackInfo.genre,
                         isLoved: trackInfo.isLoved,
                         artwork: trackInfo.artwork,
                         skipCount: trackInfo.skipCount,
                         lastPlayedDate: trackInfo.lastPlayedDate)
        }
        
        completion(songs ?? [])
    }
}
