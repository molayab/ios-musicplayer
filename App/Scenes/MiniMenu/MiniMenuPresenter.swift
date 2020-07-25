//

import UI

protocol MiniMenuPresenterProtocol: PresenterProtocol {
    func fetchMenuItems()
}

final class MiniMenuPresenter: Presenter, MiniMenuPresenterProtocol {
    struct Dependencies: PresenterDependencies { }
    
    weak var view: MiniMenuViewProtocol?
    private let dependencies: Dependencies?
    private var menuItems: [MiniMenuView.MenuItem] = []
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingView<View>(_ view: View?) {
        register(view: view)
    }
    
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

extension PresenterInjector {
    static func inject() -> MiniMenuPresenterProtocol {
        return MiniMenuPresenter(dependencies: nil)
    }
}
