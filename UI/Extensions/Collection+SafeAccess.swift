//
//  Collection+SafeAccess.swift
//  MusicPlayerUI
//
//  Created by Mateo Olaya Bernal on 24/04/20.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

