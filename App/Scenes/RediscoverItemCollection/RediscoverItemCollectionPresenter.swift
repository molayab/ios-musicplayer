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
    
    func usingView<View>(_ view: View?) where View: RediscoverItemCollectionViewProtocol {
        self.view = view
    }
    
    func usingView<View>(_ view: View?) where View: SceneProtocol {
        fatalError("Please use the correct view protocol to interact with this presenter, generic ones are not allowed.")
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
