//

protocol Presenter {
    init(dependencies: PresenterDependencies?)
}

protocol PresenterDependencies { }
extension DependencyInjector: PresenterDependencies { }
