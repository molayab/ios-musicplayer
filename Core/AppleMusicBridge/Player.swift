//
//  Player.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

/// Apple Music bridge (see `docs/agents/viability.md`): a single
/// system-level playback stream backed by `MPMusicPlayerController`/
/// `MusicKit`. This shape — one queue, one `nowPlaying` — is intentional
/// here: Apple Music catalog tracks are DRM-protected, so system playback
/// really is a single black-box stream. It is **not** the DJ deck/mixing
/// model; see `Deck` and `MixingSession` for local-file playback.
public protocol Player: AnyObject {
    var repeatMode: Any { get set }
    var shuffleMode: Any { get set }
    var volume: Float { get set }
    var nowPlaying: Playable? { get }

    func setQueue<Q: Query>(forQuery query: Q)
    func prepare(_ completion: (Result<Playable, Error>) -> Void)
    func skipNext()
    func skipPrevious()
    func skipBegining()

    func queueNext(query: Query)
    func queueForLater(query: Query)
}
