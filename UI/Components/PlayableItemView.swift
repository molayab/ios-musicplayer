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
                coverArtImage: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        
        if let coverArtImage = coverArtImage {
            self.coverArtImage = coverArtImage
        } else {
            self.coverArtImage = Constants.defaultCoverArtImage
        }
    }

    public var body: some View {
        VStack {
            Image(uiImage: coverArtImage)
                .resizable()
                .cornerRadius(8)
                .aspectRatio(contentMode: .fit)
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(Color(Constants.colors.textPrimaryColor.colorized))
                .lineLimit(1)
                .truncationMode(.tail)
            subtitle.map {
                Text($0)
                    .font(.caption)
                    .foregroundColor(
                        Color(Constants.colors.textSecundaryColor.colorized))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

// MARK: - Debug

struct PlayableItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlayableItemView(title: "My Song",
                         subtitle: "My Artists Feat Others.",
                         coverArtImage: nil)
            .background(Color.black)
    }
}
