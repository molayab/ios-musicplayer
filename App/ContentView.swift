//
import SwiftUI

struct ContentView: View {
    @ViewBuilder var body: some View {
        PlayerContainerView {
            HomeView(dependencies: .init())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
