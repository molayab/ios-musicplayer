//

import SwiftUI

protocol LibraryViewProtocol: AnyObject {
}

struct LibraryView: View {
    typealias Presenter = LibraryPresenterProtocol
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.items) { item in
                    Text(item.title)
                }
            }
        }
        .navigationTitle("Your Library")
    }
}

// MARK: - ViewModels

extension LibraryView {
    struct Item: Identifiable {
        let id: ObjectIdentifier
        let title: String
    }
    
    final class ViewModel: ObservableObject {
        var presenter: Presenter?
        init(presenter: Presenter?) {
            self.presenter = presenter
            self.presenter?.view = self
        }
        
        @Published var items: [Item] = []
    }
    
    init(presenter: Presenter) {
        self.viewModel = ViewModel(presenter: presenter)
    }
}

extension LibraryView.ViewModel: LibraryViewProtocol {
}

// MARK: - Previews

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(presenter: LibraryPresenter())
    }
}
