//

protocol LibraryPresenterProtocol {
    var view: LibraryViewProtocol? { get set }
}

final class LibraryPresenter: LibraryPresenterProtocol {
    weak var view: LibraryViewProtocol?
}

extension PresenterDependencies {
    static func inject() -> LibraryPresenterProtocol {
        return LibraryPresenter()
    }
}
