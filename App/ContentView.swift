//
import SwiftUI

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    @ViewBuilder var body: some View {
        #if os(iOS)
        Text("Hello")
        #else
        // AppSidebarNavigation()
        //     .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
