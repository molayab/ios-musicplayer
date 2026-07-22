//
//  TrackAnalyzer.swift
//  Core
//
//  BPM/musical-key detection: viability.md flags this as "the single biggest
//  unknown in the whole pivot" — no first-party iOS API provides it, and DSP
//  beat-detection is a real project of its own. This protocol exists to
//  make that extension point explicit and scoped rather than silently
//  absent; UnimplementedTrackAnalyzer is the honest placeholder until a real
//  analyzer is scoped and built.
//

public struct TrackAnalysis: Sendable, Equatable {
    public var bpm: Double?
    public var musicalKey: String?

    public init(bpm: Double? = nil, musicalKey: String? = nil) {
        self.bpm = bpm
        self.musicalKey = musicalKey
    }
}

public protocol TrackAnalyzer: Sendable {
    func analyze(_ track: Track) async throws -> TrackAnalysis
}

public struct UnimplementedTrackAnalyzer: TrackAnalyzer {
    public init() {}

    public func analyze(_ track: Track) async throws -> TrackAnalysis {
        TrackAnalysis()
    }
}
