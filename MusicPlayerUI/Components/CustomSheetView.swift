//
//  CustomSheetView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct CustomSheetView: View {
    @Binding var currentHeight: CGFloat
    @Binding var movingOffset: CGFloat

    public var body: some View {
        SheetView(currentHeight: self.$currentHeight,
                  movingOffset: self.$movingOffset,
                  smallHeight: 200,
                  onDragEnd: { position in
            // Do things on drag End
        }) {
            ZStack(alignment: .top) {
                MiniPlayerView(currentHeight: self.$currentHeight,
                               movingOffset: self.$movingOffset)
                .offset(y: self.movingOffset)
                // PlayerView().offset(y: self.currentHeight == 0  ? -100 : 0)
            }
            .background(Color.white)
        }
    }
}
