//
//  ProgressBarView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
public struct ProgressBarView: View {
    private let value: Double
    private let maxValue: Double
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let height: CGFloat

    public var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                if self.backgroundEnabled {
                    Rectangle()
                        .frame(height: self.height)
                        .foregroundColor(self.backgroundColor)
                }

                Rectangle()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width))
                    .frame(height: self.height)
                    .foregroundColor(self.foregroundColor)
                    .animation(.easeIn)
            }
        }
    }

    public init(value: Double,
                maxValue: Double,
                backgroundEnabled: Bool = true,
                backgroundColor: Color = Color.gray,
                foregroundColor: Color = Color.red,
                height: CGFloat = 10) {
        self.value = value
        self.maxValue = maxValue
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.height = height
    }
}

private extension ProgressBarView {
    func progress(value: Double,
                          maxValue: Double,
                          width: CGFloat) -> CGFloat {
        let percentage = value / maxValue
        return width * CGFloat(percentage)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
