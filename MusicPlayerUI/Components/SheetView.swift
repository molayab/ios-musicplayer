//
//  SheetView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct SheetView<Content>: View where Content: View {
    public typealias DragEndCompletion = (_ position: Position) -> Void
    public enum Position {
        case up
        case down
    }

    @Binding var currentHeight: CGFloat
    @Binding var movingOffset: CGFloat

    public var position = Position.up
    public var smallHeight: CGFloat = 50
    public var onDragEnd: DragEndCompletion = { _ in }
    public var content: () -> Content

    public var body: some View {
        Group(content: self.content)
        .cornerRadius(8)
        .frame(minHeight: 0.0, maxHeight: .infinity, alignment: .bottom)
        .offset(y: self.movingOffset)
        .gesture(
            DragGesture()
                .onChanged(self.onDragChanged)
                .onEnded(self.onDragEnd)
        )
        .edgesIgnoringSafeArea(.all)
    }
}

private extension SheetView {
    func onDragEnd(_ drag: DragGesture.Value) {
        withAnimation(.spring(dampingFraction: 0.7)) {
            if movingOffset > -50 {
                movingOffset = 0.0
                self.onDragEnd(.up)
            }

            if drag.translation.height > 80 {
                movingOffset = smallHeight
                onDragEnd(.down)
            }

            currentHeight = movingOffset
        }
    }

    func onDragChanged(_ drag: DragGesture.Value) {
        if movingOffset >= 0 {
            movingOffset = drag.translation.height + currentHeight
        }
    }
}
