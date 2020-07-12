//

import SwiftUI
import UI

protocol HomeViewProtocol: AnyObject {
    func reloadSongsWith(context: [HomeView.SongItemViewModel])
}

struct HomeView: View {
    typealias Presenter = HomeViewPresenterProtocol
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                MiniMenuView(presenter: MiniMenuPresenter())
                
                VStack(alignment: .leading) {
                    Text("Discover")
                        .font(.title)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                    
                    PlayableItemCollectionView(
                        presenter: DiscoverPlayableItemCollectionPresenter())
                }
                Spacer()
            }
            .navigationBarTitle(Text("Music"))
        }
    }
    
    init(presenter: Presenter) {
        self.viewModel = .init(presenter: presenter)
    }
}

// MARK: - HomeView's ViewModels definitions

extension HomeView {
    struct TestViewModel {
        let title: String
    }
    
    struct SongItemViewModel {
        let title: String
        let artist: String
        let album: String
    }
    
    final class ViewModel: ObservableObject {
        var presenter: Presenter?
        init(presenter: Presenter?) {
            self.presenter = presenter
            self.presenter?.view = self
        }
        
        @Published var starredSongItems: [SongItemViewModel] = []
        @Published var testViewModel: TestViewModel?
    }
}

// MARK: - HomeView.ViewModel Proxy Iface

extension HomeView.ViewModel: HomeViewProtocol {
    func reloadSongsWith(context: [HomeView.SongItemViewModel]) {
        print("foo... reloading songs with context \(context.debugDescription)")
        testViewModel = .init(title: "Hello World!")
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presenter: HomeViewPresenter())
    }
}
