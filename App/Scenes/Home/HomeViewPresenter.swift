//

import UI

protocol HomeViewPresenterProtocol: PresenterProtocol {
    func fetchStarredItems()
}

final class HomeViewPresenter: Presenter, HomeViewPresenterProtocol {
    struct Dependencies: PresenterDependencies {
        init() { }
    }
    
    weak var view: HomeViewProtocol?
    private let dependencies: Dependencies?
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingView<View>(_ view: View?) {
        register(view: view)
    }
    
    func fetchStarredItems() {
        view?.reloadSongsWith(context: [.init(title: "Test", artist: "Test", album: "Test")])
    }
}

extension PresenterInjector {
    static func inject() -> HomeViewPresenterProtocol {
        return HomeViewPresenter(dependencies: nil)
    }
}
