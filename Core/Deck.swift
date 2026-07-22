//
//  Deck.swift
//  Core
//
//  Value types shared by MixingSession's deck-scoped API. Deck control
//  itself lives on MixingSession (see MixingSession.swift) rather than on a
//  separate per-deck actor: two decks in the same session share one
//  non-Sendable AVAudioEngine, so the engine and both decks have to live in
//  a single actor isolation domain, not two independently "sendable" ones.
//

import Foundation

public enum DeckState: Sendable, Equatable {
    case empty
    case ready
    case playing
    case paused
}

public enum DeckID: Sendable, CaseIterable {
    case a
    case b
}

public struct CuePoint: Sendable, Identifiable, Equatable, Codable {
    public let id: UUID
    public var label: String
    public var position: TimeInterval

    public init(id: UUID = UUID(), label: String, position: TimeInterval) {
        self.id = id
        self.label = label
        self.position = position
    }
}
