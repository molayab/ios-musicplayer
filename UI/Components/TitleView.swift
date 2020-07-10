//

import SwiftUI

public struct TitleView: View {
    public let icon: UIImage?
    public let title: String
    
    public var body: some View {
        HStack {
            icon.map { Image(uiImage: $0) }
            Text(title)
                .font(.headline)
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(icon: nil,
                  title: "Your Songs")
    }
}
