//

import Core

protocol GetSongsUseCaseProtocol {
    func run(completion: @escaping ([MediaItem]) -> Void)
}

final class GetSongsUseCase: GetSongsUseCaseProtocol {
    struct Dependencies {
        var songsProvider: CoreLibraryProviderProtocol = CoreLibraryProvider(
            dependencies: .init(
                query: BuiltInQueryProvider(
                    initialSet: .songs)))
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func run(completion: @escaping ([MediaItem]) -> Void) {
        dependencies.songsProvider.allItems(completion: completion)
    }
}
