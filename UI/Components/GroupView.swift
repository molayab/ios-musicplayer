//

import SwiftUI

public struct GroupView: View {
    public let title: String
    public let icon: UIImage?
    
    public var body: some View {
        VStack {
            TitleView(icon: icon,
                      title: title)
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(title: "Starred Items",
                  icon: nil)
    }
}
