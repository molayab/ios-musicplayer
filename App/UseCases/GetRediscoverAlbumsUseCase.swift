//

import Foundation
import Core

protocol GetRediscoverAlbumsUseCaseProtocol {
    func run(completion: @escaping ([MediaItem]) -> Void)
}

final class GetRediscoverAlbumsUseCase: GetRediscoverAlbumsUseCaseProtocol {
    struct Dependencies {
        var albumsProvider: CoreLibraryProviderProtocol = CoreLibraryProvider(
            dependencies: .init(
                query: BuiltInQueryProvider(
                    initialSet: .albums)))
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func run(completion: @escaping ([MediaItem]) -> Void) {
        dependencies.albumsProvider.allCollections(usingFilters: nil) { mediaItems in
            let skipSum = mediaItems.reduce(0) { $0 + $1.skipCount }
            let context = mediaItems.shuffled().filter { mediaItem -> Bool in
                let targetDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
                if let lastPlayedDate = mediaItem.lastPlayedDate, let targetDate = targetDate {
                    return lastPlayedDate < targetDate
                        && Double(mediaItem.skipCount / skipSum) < 0.1
                }
                
                return mediaItem.skipCount == 0
            }
            
            completion(Array(context.prefix(30)))
        }
    }
}
