//
//  PlayableItemView.swift
//  UI
//
//  Created by Mateo Olaya Bernal on 27/04/20.
//

import SwiftUI

public struct PlayableItemView: View {
    public struct Constants {
        public static let colors = Theme.default.colors
        public static let defaultCoverArtImage = UIImage(
            named: "defaultCoverArt",
            in: Bundle(for: Theme.self),
            compatibleWith: nil
        )!
    }

    public let title: String
    public let subtitle: String?
    public let coverArtImage: UIImage

    public init(title: String,
                subtitle: String?,
                coverArtImage: UIImage = Constants.defaultCoverArtImage) {
        self.title = title
        self.subtitle = subtitle
        self.coverArtImage = coverArtImage
    }

    public var body: some View {
        VStack {
            Image(uiImage: coverArtImage)
                .resizable()
                .frame(maxWidth: 200, maxHeight: 200)
                .cornerRadius(8)
            Text(title)
                .foregroundColor(Color(Constants.colors.textPrimaryColor.colorized))
            subtitle.map {
                Text($0)
                    .foregroundColor(
                        Color(Constants.colors.textSecundaryColor.colorized))
            }
        }
    }
}

// MARK: - Debug

struct PlayableItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlayableItemView(title: "My Song", subtitle: "My Artists Feat Others.")
            .background(Color.black)
    }
}
