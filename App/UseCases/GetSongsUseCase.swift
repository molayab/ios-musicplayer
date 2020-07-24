//

import Core

protocol GetSongsUseCaseProtocol {
    func run(completion: @escaping ([MediaItem]) -> Void)
}

final class GetSongsUseCase: UseCase, GetSongsUseCaseProtocol {
    struct Dependencies: UseCaseDependencies {
        var songsProvider: CoreLibraryProviderProtocol = CoreLibraryProvider(
            dependencies: .init(
                query: BuiltInQueryProvider(
                    initialSet: .songs)))
    }
    
    private let dependencies: Dependencies?
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func run(completion: @escaping ([MediaItem]) -> Void) {
        dependencies?.songsProvider.allItems(completion: completion)
    }
}

extension UseCaseInjector {
    static func inject() -> GetSongsUseCaseProtocol {
        return GetSongsUseCase(dependencies: .init())
    }
}
