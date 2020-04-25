//
//  GridStack.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct GridStackView<Content: View>: View {
    public let rows: Int
    public let columns: Int
    public let content: (Int, Int) -> Content

    public init(rows: Int,
                columns: Int,
                @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<self.rows, id: \.self) { row in
                HStack(spacing: -15) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}
