//

import Foundation

final class DependencyInjector {
    /// All memory-shared objects must be injected once using a defined key.
    ///  this allows use keep which are the objects stored on memory as singleton
    ///  and tries to avoid the abuse of this pattern.
    /// The main idea is avoid singletons and use them only when are 100% required.
    /// For a simple injection just overload the default inject() static funcion
    ///  extending the protocol in your file context.
    enum Key {
        case test
    }
    
    private static var instances: [Key: AnyObject] = [:]
    private static let dispatchQueue = DispatchQueue(label: "app.dependency-injector.distpatchQueue",
                                                     attributes: .concurrent)
    
    static func injectOnce<S: AnyObject>(for key: Key, singleton: S) -> S {
        return dispatchQueue.sync {
            if let instance = instances[key] {
                return instance as! S
            }
            
            instances[key] = singleton
            return instances[key] as! S
        }
    }
    
    static func deallocInstance(forKey key: Key) {
        dispatchQueue.async(flags: .barrier) {
            instances.removeValue(forKey: key)
        }
    }
}
