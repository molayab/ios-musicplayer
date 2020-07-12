//

import SwiftUI

struct PlayerContainerView<Content: View>: View {
    public let content: () -> Content
    
    var body: some View {
        VStack {
            content()
            Spacer()
            Rectangle() // TODO: Set the player view
                .frame(minHeight: 85,
                       maxHeight: 85,
                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(8)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 8)
        }
    }
}

struct PlayerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerContainerView {
            Text("Content")
        }
    }
}
