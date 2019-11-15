import UIKit
import PullUpController

protocol DirectionsRouterProtocol
{
}

class DirectionsRouter: NSObject, DirectionsRouterProtocol
{
    private weak var _viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        _viewController = viewController
    }
    
    // MARK: - Logic
}
