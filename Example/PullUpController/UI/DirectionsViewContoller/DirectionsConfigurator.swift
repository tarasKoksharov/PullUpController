import Foundation
import UIKit

protocol DirectionsConfiguratorProtocol {
    func configure(_ view: DirectionsDisplayProtocol) -> DirectionsPresenterProtocol
}

class DirectionsConfigurator: DirectionsConfiguratorProtocol {
    
    func configure(_ view: DirectionsDisplayProtocol) -> DirectionsPresenterProtocol {
        
        var router: DirectionsRouter?
        
        if let view = view as? UIViewController {
            router = DirectionsRouter(viewController: view)
        }
        
        return DirectionsPresenter(view: view,
                                   router: router)
    }
}
