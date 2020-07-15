//

import UI

protocol HomeViewPresenterProtocol {
    var view: HomeViewProtocol? { get set }
    
    func fetchStarredItems()
}

final class HomeViewPresenter: HomeViewPresenterProtocol {
    weak var view: HomeViewProtocol?
    func fetchStarredItems() {
        view?.reloadSongsWith(context: [.init(title: "Test", artist: "Test", album: "Test")])
    }
}

extension PresenterDependencies {
    static func inject() -> HomeViewPresenterProtocol {
        return HomeViewPresenter()
    }
}
