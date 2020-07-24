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
    
    func usingView<View>(_ view: View?) where View: LibraryViewProtocol {
        self.view = view
    }
    
    func usingView<View>(_ view: View?) where View: SceneProtocol {
        fatalError("Please use the correct view protocol to interact with this presenter, generic ones are not allowed.")
    }
}

extension PresenterInjector {
    static func inject() -> LibraryPresenterProtocol {
        return LibraryPresenter(dependencies: .init())
    }
}
