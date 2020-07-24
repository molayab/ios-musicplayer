//

import SwiftUI
import UI

protocol HomeViewProtocol: SceneProtocol {
    func reloadSongsWith(context: [HomeView.SongItemViewModel])
}

struct HomeView: View {
    struct Dependencies: ViewDependencies {
        var homePresenter: HomeViewPresenterProtocol = inject()
        var libraryPresenter: LibraryPresenterProtocol = inject()
        var rediscoverItemCollectionPresenter: RediscoverItemCollectionPresenterProtocol = inject()
        var miniMenuPresenter: MiniMenuPresenterProtocol = inject()
    }
    
    typealias Presenter = HomeViewPresenterProtocol
    @ObservedObject private var viewModel: ViewModel
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewModel = ViewModel(presenter: dependencies.homePresenter)
    }
    
    var miniMenuView: some View {
        MiniMenuView(presenter: dependencies.miniMenuPresenter)
    }
    
    var rediscoverItemCollectionView: some View {
        RediscoverItemCollectionView(
            presenter: dependencies.rediscoverItemCollectionPresenter)
    }
    
    var libraryView: some View {
        LibraryView(presenter: dependencies.libraryPresenter)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                miniMenuView
                
                VStack(alignment: .leading) {
                    NavigationLink(destination: libraryView) {
                        VStack(alignment: .leading) {
                            Text("Your Library")
                                .font(.headline)
                                .accentColor(.primary)
                            Text("Rediscover some items from your local library")
                                .font(.subheadline)
                                .accentColor(.secondary)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                    }
                    
                    rediscoverItemCollectionView
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("Home"))
        }
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
        var presenter: HomeViewPresenterProtocol?
        init(presenter: HomeViewPresenterProtocol?) {
            self.presenter = presenter
            self.presenter?.usingView(self)
        }
        
        @Published var starredSongItems: [SongItemViewModel] = []
        @Published var testViewModel: TestViewModel?
    }
}

extension HomeView.ViewModel: HomeViewProtocol {
    func reloadSongsWith(context: [HomeView.SongItemViewModel]) {
        print("foo... reloading songs with context \(context.debugDescription)")
        testViewModel = .init(title: "Hello World!")
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dependencies: .init())
    }
}
