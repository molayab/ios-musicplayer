//
//  AudioEngineDeck.swift
//  Core
//
//  One playback chain (player -> time/pitch -> per-deck gain) inside a
//  MixingSession's AVAudioEngine graph. Raw PCM playback via
//  AVAudioPlayerNode is what unlocks DJ features (tempo/pitch, gain, cue
//  points, simultaneous multi-deck output) that are categorically
//  unavailable for Apple Music catalog tracks (DRM) — only usable with the
//  user's own local files. See docs/agents/viability.md.
//
//  Deliberately internal, not `public`, and not an `actor`: it shares a
//  single non-Sendable AVAudioEngine with its sibling deck, so MixingSession
//  is the sole owner and sole isolation domain for both of them.
//

import AVFoundation

final class AudioEngineDeck {
    private(set) var state: DeckState = .empty
    private(set) var track: Track?
    private(set) var cuePoints: [CuePoint] = []
    private(set) var tempoAdjustment: Float = 0
    private(set) var gain: Float = 1

    private let engine: AVAudioEngine
    private let playerNode = AVAudioPlayerNode()
    private let timePitch = AVAudioUnitTimePitch()
    private let outputMixer = AVAudioMixerNode()

    private var audioFile: AVAudioFile?
    private var sampleRate: Double = 44_100
    private var seekOffset: TimeInterval = 0
    private var isScheduled = false

    var outputNode: AVAudioNode { outputMixer }

    init(engine: AVAudioEngine) {
        self.engine = engine
        engine.attach(playerNode)
        engine.attach(timePitch)
        engine.attach(outputMixer)
        engine.connect(playerNode, to: timePitch, format: nil)
        engine.connect(timePitch, to: outputMixer, format: nil)
    }

    var currentTime: TimeInterval {
        guard let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
            return seekOffset
        }
        return seekOffset + Double(playerTime.sampleTime) / playerTime.sampleRate
    }

    func load(_ track: Track) throws {
        stop()
        let url = try track.resolveSecurityScopedURL()
        defer { url.stopAccessingSecurityScopedResource() }

        let file = try AVAudioFile(forReading: url)
        audioFile = file
        sampleRate = file.processingFormat.sampleRate
        self.track = track
        seekOffset = 0
        isScheduled = false
        state = .ready
    }

    func play() {
        guard let file = audioFile, state != .playing else { return }
        if !isScheduled {
            scheduleSegment(of: file, from: seekOffset)
            isScheduled = true
        }
        if !engine.isRunning {
            try? engine.start()
        }
        playerNode.play()
        state = .playing
    }

    func pause() {
        guard state == .playing else { return }
        playerNode.pause()
        state = .paused
    }

    func stop() {
        playerNode.stop()
        isScheduled = false
        seekOffset = 0
        state = audioFile == nil ? .empty : .ready
    }

    func seek(to time: TimeInterval) {
        guard let file = audioFile else { return }
        let wasPlaying = state == .playing
        playerNode.stop()
        isScheduled = false
        seekOffset = max(0, min(time, Double(file.length) / sampleRate))
        state = .ready
        if wasPlaying {
            play()
        }
    }

    func setTempoAdjustment(_ percentage: Float) {
        tempoAdjustment = percentage
        timePitch.rate = 1 + percentage
    }

    func setGain(_ value: Float) {
        gain = max(0, min(value, 1))
        outputMixer.outputVolume = gain
    }

    @discardableResult
    func addCuePoint(at time: TimeInterval, label: String) -> CuePoint {
        let cue = CuePoint(label: label, position: time)
        cuePoints.append(cue)
        return cue
    }

    func jump(to cuePoint: CuePoint) {
        seek(to: cuePoint.position)
    }

    func removeCuePoint(_ cuePoint: CuePoint) {
        cuePoints.removeAll { $0.id == cuePoint.id }
    }

    private func scheduleSegment(of file: AVAudioFile, from time: TimeInterval) {
        let startFrame = AVAudioFramePosition(time * sampleRate)
        let frameCount = AVAudioFrameCount(max(0, file.length - startFrame))
        guard frameCount > 0 else { return }
        playerNode.scheduleSegment(file, startingFrame: startFrame, frameCount: frameCount, at: nil)
    }
}
