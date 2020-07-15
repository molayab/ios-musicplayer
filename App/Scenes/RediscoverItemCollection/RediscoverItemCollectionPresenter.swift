//

import UI

protocol RediscoverItemCollectionPresenterProtocol {
    var view: RediscoverItemCollectionViewProtocol? { get set }
    
    func fetchItems()
}

// MARK: - Available Presenters

final class RediscoverItemCollectionPresenter: RediscoverItemCollectionPresenterProtocol {
    struct Dependencies {
        var getRediscoverAlbumsUseCase: GetRediscoverAlbumsUseCaseProtocol = GetRediscoverAlbumsUseCase()
    }
    
    weak var view: RediscoverItemCollectionViewProtocol?
    private var items: [RediscoverItemCollectionView.Item] = []
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func fetchItems() {
        dependencies.getRediscoverAlbumsUseCase.run { [unowned self] items in
            let items = items.map { item -> RediscoverItemCollectionView.Item in
                return .init(title: item.album ?? "",
                             subtitle: item.albumArtist ?? "",
                             artwork: item.artwork)
            }
            
            self.view?.reload(items: items)
        }
    }
}

extension PresenterDependencies {
    static func inject() -> RediscoverItemCollectionPresenterProtocol {
        return RediscoverItemCollectionPresenter()
    }
}
