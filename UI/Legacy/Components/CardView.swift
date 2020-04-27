//
//  CardView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct CardView: View {
    public enum CardType {
        case searchable
        case playable
    }

    public var title: String
    public var subtitle: String?
    public var coverArt: CGImage?
    public var squareSize: CGFloat = 105.0

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                ZStack {
                    Image("media1")
                       .resizable()
                       .scaledToFit()
                       .frame(width: squareSize, height: squareSize)
                       .cornerRadius(8.0)

                    Button(action: { }) {
                        Image("play")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .accentColor(Color.gray.opacity(0.9))
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                }

                Text(title)
                    .font(.headline)
                    .frame(maxWidth: squareSize)
                    .allowsHitTesting(true)
                    .truncationMode(.tail)
                    .lineLimit(1)
                subtitle.map {
                    Text($0)
                        .font(.subheadline)
                        .frame(maxWidth: squareSize)
                        .allowsHitTesting(true)
                        .truncationMode(.tail)
                        .lineLimit(1)
                }
            }

            Button(action: { }) {
                Image("dots")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .trailing)
                    .accentColor(Color.gray.opacity(0.9))
                    .padding(5)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8.0)
                    .rotationEffect(.radians(.pi / 2))
            }
        }
        .padding(.leading, 0)
        .padding(.trailing, 0)
        .padding(.bottom, 10)
    }

    public init(title: String,
                subtitle: String?,
                coverArt: CGImage?,
                squareSize: CGFloat = 105.0) {
        self.title = title
        self.subtitle = subtitle
        self.coverArt = coverArt
        self.squareSize = squareSize
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Sample title",
                 subtitle: "Sample subtitle",
                 coverArt: nil,
                 squareSize: 0.0)
    }
}
