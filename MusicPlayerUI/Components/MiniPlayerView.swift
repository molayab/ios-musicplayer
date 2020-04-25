//
//  MiniPlayerView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct MiniPlayerView: View {
    @Binding var currentHeight: CGFloat
    @Binding var movingOffset: CGFloat

    public var body: some View {
        VStack(alignment: .leading) {
            ProgressBarView(value: 5, maxValue: 15)
            HStack(alignment: .center) {
                Image("media1")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                    Text("Artist")
                }
                Spacer()
                HStack {
                    Button(action: { }) {
                        Image("play")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                            .accentColor(.black)
                    }
                    Button(action: { }) {
                        Image("next")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                            .accentColor(.black)
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 0.0, maxWidth: .infinity)
        .frame(height: 80)
        .onTapGesture {
            withAnimation(.spring(dampingFraction: 0.7)) {
                self.currentHeight = 0.0
                self.movingOffset = 0.0
            }
        }
        .background(BluredView())
    }
}
