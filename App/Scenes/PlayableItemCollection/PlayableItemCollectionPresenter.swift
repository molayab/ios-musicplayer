//

import UI

protocol PlayableItemCollectionPresenterProtocol {
    var view: PlayableItemCollectionViewProtocol? { get set }
    
    func fetchItems()
}

// MARK: - Available Presenters

final class DiscoverPlayableItemCollectionPresenter: PlayableItemCollectionPresenterProtocol {
    weak var view: PlayableItemCollectionViewProtocol?
    private var items: [PlayableItemCollectionView.Item] = []
    
    func fetchItems() {
        items = Array(repeating: .init(title: "Song 1", subtitle: "Artist 1"), count: 25)
        view?.reload(items: items)
    }
}

