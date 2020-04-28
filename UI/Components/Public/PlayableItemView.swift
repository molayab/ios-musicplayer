//
//  PlayableItemView.swift
//  UI
//
//  Created by Mateo Olaya Bernal on 27/04/20.
//

import SwiftUI

public struct PlayableItemView: View {
    let image = UIImage(named: "defaultCoverArt", in: Bundle(for: Theme.self), compatibleWith: nil)

    public var body: some View {
        VStack {
            image.map {
                Image(uiImage: $0)
                    .resizable()
                .frame(maxWidth: 200, maxHeight: 200)
            }
            Text("Title")
            Text("Subtitle")
        }
    }
}

struct PlayableItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlayableItemView()
    }
}
