//

import SwiftUI
import UI

protocol MiniMenuViewProtocol: SceneProtocol {
    func reload(menuItems: [MiniMenuView.MenuItem])
}

struct MiniMenuView: View {
    typealias Presenter = MiniMenuPresenterProtocol
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GridStackView(rows: 2, columns: viewModel.maxMenuItemsPerColumn) { row, column in
                self.getGridStackView(row: row, column: column, maxColumns: viewModel.maxMenuItemsPerColumn)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 2.5)
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
        }
        .onAppear {
            viewModel.presenter?.fetchMenuItems()
        }
    }
    
    private func getGridStackView(row: Int, column: Int, maxColumns: Int) -> some View {
        let index = (column + (row * maxColumns))
        return viewModel.menuItems[safe: index].map { MiniMenuItemView(title: $0.title) }
    }
    
    init(presenter: Presenter?) {
        self.viewModel = ViewModel(presenter: presenter)
    }
}

// MARK: - ViewModels

extension MiniMenuView {
    struct MenuItem {
        let title: String
    }
    
    final class ViewModel: ObservableObject {
        var presenter: Presenter?
        init(presenter: Presenter?) {
            self.presenter = presenter
            self.presenter?.usingScene(self)
        }
        
        @Published var menuItems: [MenuItem] = []
        var maxMenuItemsPerColumn: Int {
            return Int((Double(menuItems.count) / 2.0).rounded(.up))
        }
    }
}

extension MiniMenuView.ViewModel: MiniMenuViewProtocol {
    func reload(menuItems: [MiniMenuView.MenuItem]) {
        self.menuItems = menuItems
    }
}

// MARK: - Previews

struct MiniMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMenuView(presenter: MiniMenuPresenter(dependencies: nil))
    }
}
