//

import UI

protocol MiniMenuPresenterProtocol {
    var view: MiniMenuViewProtocol? { get set }
    
    func fetchMenuItems()
}

final class MiniMenuPresenter: MiniMenuPresenterProtocol {
    weak var view: MiniMenuViewProtocol?
    private var menuItems: [MiniMenuView.MenuItem] = []
    
    func fetchMenuItems() {
        menuItems = [
            .init(title: "Playlists"),
            .init(title: "Artists"),
            .init(title: "Albums"),
            .init(title: "Songs"),
            .init(title: "Music Videos"),
            .init(title: "Genres"),
            .init(title: "Compilations"),
            .init(title: "Composers"),
        ]
        
        view?.reload(menuItems: menuItems)
    }
}

extension PresenterDependencies {
    static func inject() -> MiniMenuPresenterProtocol {
        return DependencyInjector.injectOnce(for: .test, singleton: MiniMenuPresenter())
    }
}
