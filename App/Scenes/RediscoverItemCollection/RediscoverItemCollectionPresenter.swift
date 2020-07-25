//

import UI

protocol RediscoverItemCollectionPresenterProtocol: PresenterProtocol {
    func fetchItems()
}

// MARK: - Available Presenters

final class RediscoverItemCollectionPresenter: Presenter, RediscoverItemCollectionPresenterProtocol {
    struct Dependencies: PresenterDependencies {
        var getRediscoverAlbumsUseCase: GetRediscoverAlbumsUseCaseProtocol = inject()
    }
    
    weak var view: RediscoverItemCollectionViewProtocol?
    private let dependencies: Dependencies?
    private var items: [RediscoverItemCollectionView.Item] = []
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingView<View>(_ view: View?) {
        register(view: view)
    }
    
    func fetchItems() {
        dependencies?.getRediscoverAlbumsUseCase.run { [unowned self] items in
            let items = items.map { item -> RediscoverItemCollectionView.Item in
                return .init(title: item.album ?? "",
                             subtitle: item.albumArtist ?? "",
                             artwork: item.artwork)
            }
            
            self.view?.reload(items: items)
        }
    }
}

extension PresenterInjector {
    static func inject() -> RediscoverItemCollectionPresenterProtocol {
        return RediscoverItemCollectionPresenter(dependencies: .init())
    }
}
