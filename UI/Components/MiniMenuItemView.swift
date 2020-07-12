//

import SwiftUI

public struct MiniMenuItemView: View {
    public let title: String
    public let subtitle: String?
    
    public var body: some View {
        Button(action: { }) {
            VStack {
                Text(title)
                    .font(.headline)
                subtitle.map {
                    Text($0)
                        .font(.subheadline)
                }
            }
            .frame(minWidth: Theme.default.mainScreenSize.width / 3,
                   minHeight: 30)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.top, 5)
            .padding(.bottom, 5)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}

struct MiniMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MiniMenuItemView(title: "Title", subtitle: "Subtitle")
    }
}
