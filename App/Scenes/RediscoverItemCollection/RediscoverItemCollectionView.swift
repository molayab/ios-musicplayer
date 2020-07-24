//

import SwiftUI
import UI

protocol RediscoverItemCollectionViewProtocol: SceneProtocol {
    func reload(items: [RediscoverItemCollectionView.Item])
}

struct RediscoverItemCollectionView: View {
    typealias Presenter = RediscoverItemCollectionPresenterProtocol
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GridStackView(rows: 2, columns: viewModel.maxItemsPerColumn) { row, column in
                self.getGridStackView(row: row, column: column, maxColumns: viewModel.maxItemsPerColumn)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
        }
        .onAppear {
            viewModel.presenter?.fetchItems()
        }
    }
    
    private func getGridStackView(row: Int, column: Int, maxColumns: Int) -> some View {
        let index = (column + (row * maxColumns))
        return viewModel.items[safe: index].map {
            PlayableItemView(title: $0.title,
                             subtitle: $0.subtitle,
                             coverArtImage: $0.artwork())
                .frame(width: 125)
        }
    }
    
    init(presenter: Presenter?) {
        self.viewModel = ViewModel(presenter: presenter)
    }
}

// MARK: - ViewModels

extension RediscoverItemCollectionView {
    struct Item {
        let title: String
        let subtitle: String
        let artwork: (() -> UIImage?)
    }
    
    final class ViewModel: ObservableObject {
        var presenter: Presenter?
        init(presenter: Presenter?) {
            self.presenter = presenter
            self.presenter?.usingView(self)
        }
        
        @Published var items: [Item] = []
        var maxItemsPerColumn: Int {
            return Int((Double(items.count) / 2.0).rounded(.up))
        }
    }
}

extension RediscoverItemCollectionView.ViewModel: RediscoverItemCollectionViewProtocol {
    func reload(items: [RediscoverItemCollectionView.Item]) {
        self.items = items
    }
}

// MARK: - Previews

struct PlayableItemCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        RediscoverItemCollectionView(presenter: RediscoverItemCollectionPresenter(dependencies: .init()))
    }
}
