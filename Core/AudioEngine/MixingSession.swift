//
//  MixingSession.swift
//  Core
//
//  Owns the shared AVAudioEngine graph and both decks, exposing deck-scoped
//  control through a DeckID parameter rather than handing out separate deck
//  objects — the engine and its decks are one non-Sendable graph, so they
//  live in a single actor isolation domain. This is the concrete answer to
//  viability.md's "DJ mixing needs two or more simultaneously loaded,
//  independently transported decks", which the old single-queue `Player`
//  (Core/AppleMusicBridge) fundamentally couldn't model.
//

import AVFoundation

public actor MixingSession {
    public private(set) var crossfade: Float = 0.5
    public private(set) var masterVolume: Float = 1

    private let engine: AVAudioEngine
    private let decks: [DeckID: AudioEngineDeck]

    public init() {
        let engine = AVAudioEngine()
        let deckA = AudioEngineDeck(engine: engine)
        let deckB = AudioEngineDeck(engine: engine)
        engine.connect(deckA.outputNode, to: engine.mainMixerNode, format: nil)
        engine.connect(deckB.outputNode, to: engine.mainMixerNode, format: nil)
        self.engine = engine
        self.decks = [.a: deckA, .b: deckB]
    }

    public func load(_ track: Track, into deck: DeckID) throws {
        try decks[deck]?.load(track)
    }

    public func play(_ deck: DeckID) {
        decks[deck]?.play()
    }

    public func pause(_ deck: DeckID) {
        decks[deck]?.pause()
    }

    public func stop(_ deck: DeckID) {
        decks[deck]?.stop()
    }

    public func seek(_ deck: DeckID, to time: TimeInterval) {
        decks[deck]?.seek(to: time)
    }

    public func setTempoAdjustment(_ percentage: Float, deck: DeckID) {
        decks[deck]?.setTempoAdjustment(percentage)
    }

    @discardableResult
    public func addCuePoint(at time: TimeInterval, label: String, deck: DeckID) -> CuePoint? {
        decks[deck]?.addCuePoint(at: time, label: label)
    }

    public func jump(to cuePoint: CuePoint, deck: DeckID) {
        decks[deck]?.jump(to: cuePoint)
    }

    public func removeCuePoint(_ cuePoint: CuePoint, deck: DeckID) {
        decks[deck]?.removeCuePoint(cuePoint)
    }

    public func state(of deck: DeckID) -> DeckState {
        decks[deck]?.state ?? .empty
    }

    public func track(on deck: DeckID) -> Track? {
        decks[deck]?.track
    }

    public func currentTime(of deck: DeckID) -> TimeInterval {
        decks[deck]?.currentTime ?? 0
    }

    public func cuePoints(on deck: DeckID) -> [CuePoint] {
        decks[deck]?.cuePoints ?? []
    }

    /// 0 = full deckA, 1 = full deckB.
    public func setCrossfade(_ value: Float) {
        crossfade = max(0, min(value, 1))
        decks[.a]?.setGain(1 - crossfade)
        decks[.b]?.setGain(crossfade)
    }

    public func setMasterVolume(_ value: Float) {
        masterVolume = max(0, min(value, 1))
        engine.mainMixerNode.outputVolume = masterVolume
    }

    public func start() throws {
        guard !engine.isRunning else { return }
        try engine.start()
    }

    public func stop() {
        engine.stop()
    }
}
