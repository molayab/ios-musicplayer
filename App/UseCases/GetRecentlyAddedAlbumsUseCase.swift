//

import Foundation

import Core

protocol GetRecentlyAddedAlbumsUseCaseProtocol {
    func run(completion: @escaping ([Int: [MediaItem]]) -> Void)
}

final class GetRecentlyAddedAlbumsUseCase: UseCase, GetRecentlyAddedAlbumsUseCaseProtocol {
    struct Dependencies: UseCaseDependencies {
        var albumsProvider: CoreLibraryProviderProtocol = injectCoreLibraryAlbumSet()
        var calendar: Calendar = .current
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func run(completion: @escaping ([Int: [MediaItem]]) -> Void) {
        dependencies.albumsProvider.allCollections(usingFilters: nil) { items in
            var collection: [Int: [MediaItem]] = [:]
            let albums = items.sorted(by: { $0.dateAdded > $1.dateAdded })
            albums.forEach { mediaItem in
                let key = dependencies.calendar.component(.year, from: mediaItem.dateAdded)
                if var value = collection[key] {
                    value.append(mediaItem)
                } else {
                    collection[key] = [mediaItem]
                }
            }
            
            completion(collection)
        }
    }
}

extension UseCaseInjector {
    static func inject() -> GetSongsUseCaseProtocol {
        return GetSongsUseCase(dependencies: .init())
    }
}
