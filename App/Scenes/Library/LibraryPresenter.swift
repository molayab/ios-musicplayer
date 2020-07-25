//

protocol LibraryPresenterProtocol: PresenterProtocol {
}

final class LibraryPresenter: Presenter, LibraryPresenterProtocol {
    typealias View = LibraryViewProtocol
    struct Dependencies: PresenterDependencies {
        var getSongsUseCase: GetSongsUseCaseProtocol = inject()
    }
    
    weak var view: LibraryViewProtocol?
    private let dependencies: Dependencies?
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingView<View>(_ view: View?) {
        register(view: view)
    }
}

extension PresenterInjector {
    static func inject() -> LibraryPresenterProtocol {
        return LibraryPresenter(dependencies: .init())
    }
}
