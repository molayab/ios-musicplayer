//
//  HomeSectionView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct HomeSectionView: View {
    public var categoryTitle: String
    public var categoryImage: CGImage
    public var title: String
    public var rows: Int
    public var columns: Int

    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(categoryTitle.uppercased())
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Text(title.capitalized)
                        .font(.title)
                        .bold()
                }
                Spacer()
                Button(action: { }) {
                    Image(decorative: categoryImage, scale: 1.0)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .accentColor(Color.red)
                        .padding(15)
                        .cornerRadius(8.0)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: -15) {
                    GridStackView(rows: rows, columns: columns) { row, column in
                        CardView(title: "Fresa Es muy largo para ",
                             subtitle: "Gordo Sarkasmus",
                             coverArt: nil)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                    }
                }
            }
            .padding(.leading, -15)
            .padding(.trailing, -15)
        }
        .padding()
    }

    public init(categoryTitle: String,
                categoryImage: CGImage,
                title: String,
                rows: Int,
                columns: Int) {
        self.categoryTitle = categoryTitle
        self.categoryImage = categoryImage
        self.title = title
        self.rows = rows
        self.columns = columns
    }
}
