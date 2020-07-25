//

import SwiftUI

protocol Provider {
    associatedtype Dependencies: ProviderDependencies
    init(dependencies: Dependencies)
}
protocol UseCase {
    associatedtype Dependencies: UseCaseDependencies
    init(dependencies: Dependencies)
}
protocol PresenterProtocol {
    func usingScene<Scene>(_ scene: Scene?)
}
protocol Presenter: AnyObject {
    associatedtype Scene
    associatedtype Dependencies: PresenterDependencies
    
    var scene: Scene? { get set }
    init(dependencies: Dependencies?)
}
extension Presenter {
    func register<S>(scene: S?) {
        guard let scene = scene as? Scene else {
            fatalError("""
                Please use the correct view protocol to interact with this presenter, generic ones
                are not allowed.
                """
            )
        }
        
        self.scene = scene
    }
}
protocol SceneProtocol: AnyObject { }
protocol Scene {
    associatedtype Dependencies: ViewDependencies
    associatedtype ViewModel: SceneViewModel
    associatedtype PP: PresenterProtocol
    init(presenter: PP?, dependencies: Dependencies?)
}
protocol SceneViewModel {
    associatedtype PP: PresenterProtocol
    init(presenter: PP?)
}
protocol ProviderInjector { }
protocol UseCaseInjector { }
protocol PresenterInjector { }
protocol SceneInjector { }
protocol ProviderDependencies: ProviderInjector { }
protocol UseCaseDependencies: UseCaseInjector, ProviderInjector { }
protocol PresenterDependencies: UseCaseInjector, PresenterInjector { }
protocol ViewDependencies: PresenterInjector, SceneInjector { }


// ARCH USAGE DEFINITION
//
//// -- USE CASE --
//
//protocol UProtocol { }
//final class U: UseCase, UProtocol {
//    struct Dependencies: UseCaseDependencies {
//        var u: UProtocol = inject()
//    }
//
//    private let dependencies: Dependencies?
//    init(dependencies: Dependencies?) {
//        self.dependencies = dependencies
//    }
//}
//
//extension UseCaseInjector {
//    static func inject() -> UProtocol {
//        return U(dependencies: nil)
//    }
//}
//
//// -- PRESENTER --
//
//protocol PProtocol { }
//final class P: Presenter, PProtocol {
//    struct Dependencies: PresenterDependencies {
//        var u: UProtocol = inject()
//        var p: HomeViewPresenterProtocol = inject()
//    }
//
//    private let dependencies: Dependencies?
//    init(dependencies: Dependencies?) {
//        self.dependencies = dependencies
//    }
//}
//
//extension PresenterInjector {
//    static func inject() -> PProtocol {
//        return P(dependencies: nil)
//    }
//}
//
///// -- VIEW --
//
//struct S: Scene {
//    struct Dependencies: ViewDependencies {
//        var p: PProtocol = inject()
//    }
//
//    private let dependencies: Dependencies?
//    private let viewModel: ViewModel
//    init(presenter: P, dependencies: Dependencies?) {
//        self.dependencies = dependencies
//        self.viewModel = ViewModel(presenter: presenter)
//    }
//}
//
//extension S {
//    final class ViewModel: SceneViewModel {
//        private let presenter: P
//        init(presenter: P) {
//            self.presenter = presenter
//        }
//    }
//}
