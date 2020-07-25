//

import UI

protocol HomeViewPresenterProtocol: PresenterProtocol {
    func fetchStarredItems()
}

final class HomeViewPresenter: Presenter, HomeViewPresenterProtocol {
    struct Dependencies: PresenterDependencies {
        init() { }
    }
    
    weak var scene: HomeViewProtocol?
    private let dependencies: Dependencies?
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingScene<Scene>(_ scene: Scene?) {
        register(scene: scene)
    }
    
    func fetchStarredItems() {
        scene?.reloadSongsWith(context: [.init(title: "Test", artist: "Test", album: "Test")])
    }
}

extension PresenterInjector {
    static func inject() -> HomeViewPresenterProtocol {
        return HomeViewPresenter(dependencies: nil)
    }
}
