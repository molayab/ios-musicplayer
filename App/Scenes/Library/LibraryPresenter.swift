//

protocol LibraryPresenterProtocol: PresenterProtocol {
}

final class LibraryPresenter: Presenter, LibraryPresenterProtocol {
    typealias View = LibraryViewProtocol
    struct Dependencies: PresenterDependencies {
        var getSongsUseCase: GetSongsUseCaseProtocol = inject()
    }
    
    weak var scene: LibraryViewProtocol?
    private let dependencies: Dependencies?
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingScene<Scene>(_ scene: Scene?) {
        register(scene: scene)
    }
}

extension PresenterInjector {
    static func inject() -> LibraryPresenterProtocol {
        return LibraryPresenter(dependencies: .init())
    }
}
