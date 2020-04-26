//
//  Player.swift
//  Core
//
//  Created by Mateo Olaya Bernal on 26/04/20.
//

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
