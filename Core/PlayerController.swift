//
//  PlayerController.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

public final class PlayerController {
    private var playerProvider: Player! // = BuiltInMusicPlayerProvider()

    public func register(playerProvider: Player) {
        self.playerProvider = playerProvider
    }
}

extension PlayerController: Player {
    public var repeatMode: Any {
        get { playerProvider.repeatMode }
        set { playerProvider.repeatMode = newValue }
    }

    public var shuffleMode: Any {
        get { playerProvider.shuffleMode }
        set { playerProvider.shuffleMode = newValue }
    }

    public var volume: Float {
        get { playerProvider.volume }
        set { playerProvider.volume = newValue }
    }

    public var nowPlaying: Playable? {
        playerProvider.nowPlaying
    }

    public func setQueue<Q: Query>(forQuery query: Q) {
        playerProvider.setQueue(forQuery: query)
    }

    public func prepare(_ completion: (Result<Playable, Error>) -> Void) {
        playerProvider.prepare(completion)
    }

    public func skipNext() {
        playerProvider.skipNext()
    }

    public func skipPrevious() {
        playerProvider.skipPrevious()
    }

    public func skipBegining() {
        playerProvider.skipBegining()
    }

    public func queueNext(query: Query) {
        playerProvider.queueNext(query: query)
    }

    public func queueForLater(query: Query) {
        playerProvider.queueForLater(query: query)
    }
}
