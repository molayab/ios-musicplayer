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
    
    weak var scene: RediscoverItemCollectionViewProtocol?
    private let dependencies: Dependencies?
    private var items: [RediscoverItemCollectionView.Item] = []
    
    init(dependencies: Dependencies?) {
        self.dependencies = dependencies
    }
    
    func usingScene<Scene>(_ scene: Scene?) {
        register(scene: scene)
    }
    
    func fetchItems() {
        dependencies?.getRediscoverAlbumsUseCase.run { [unowned self] items in
            let items = items.map { item -> RediscoverItemCollectionView.Item in
                return .init(title: item.album ?? "",
                             subtitle: item.albumArtist ?? "",
                             artwork: item.artwork)
            }
            
            self.scene?.reload(items: items)
        }
    }
}

extension PresenterInjector {
    static func inject() -> RediscoverItemCollectionPresenterProtocol {
        return RediscoverItemCollectionPresenter(dependencies: .init())
    }
}
