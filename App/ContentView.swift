//
import SwiftUI

struct ContentView: View {
    @ViewBuilder var body: some View {
        HomeView(presenter: HomeViewPresenter())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
