//
//  BluredView.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

import SwiftUI
import UIKit

struct BluredView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BluredView_Previews: PreviewProvider {
    static var previews: some View {
        BluredView()
    }
}
