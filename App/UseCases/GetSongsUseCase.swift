//

import Core

protocol GetSongsUseCaseProtocol {
    func run(completion: @escaping ([MediaItem]) -> Void)
}

final class GetSongsUseCase: UseCase, GetSongsUseCaseProtocol {
    struct Dependencies: UseCaseDependencies {
        var songsProvider: CoreLibraryProviderProtocol = injectCoreLibrarySongsSet()
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func run(completion: @escaping ([MediaItem]) -> Void) {
        dependencies.songsProvider.allItems(completion: completion)
    }
}

extension UseCaseInjector {
    static func injectCoreLibrarySongsSet() -> GetSongsUseCaseProtocol {
        return GetSongsUseCase(dependencies: .init())
    }
}
