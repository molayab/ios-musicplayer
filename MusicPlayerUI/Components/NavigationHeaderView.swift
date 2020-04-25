//
//  NavigationHeaderView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct NavigationHeaderView: View {
    public enum OptionModel: String {
        case songs
        case playlists
        case composers
        case compilations
        case albums
        case artists
        case genres
        case settings
    }

    public let options: [OptionModel]
    private var maxItemsPerColumn: Int {
        return Int((Double(options.count) / 2.0).rounded(.up))
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GridStackView(rows: 2, columns: self.maxItemsPerColumn) { row, column in
                Button(action: { }) {
                    self.options[safe: (column + (row * self.maxItemsPerColumn))].map { option in
                        HStack {
                            Text(option.rawValue)
                                .font(.caption)
                                .accentColor(.black)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image("right-arrow")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .accentColor(.secondary)
                        }
                        .frame(width: 130)
                        .padding()
                    }
                }
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .cornerRadius(8)
                .padding(.top, 5)
                .padding(.leading, 15)
                .padding(.trailing, 15)
            }
        }
    }

    public init(options: [OptionModel]) {
        self.options = options
    }
}
