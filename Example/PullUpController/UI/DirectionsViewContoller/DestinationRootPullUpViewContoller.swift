import Foundation
import PullUpController

enum DestinationPullUpPosition {
    case top
    case middle
    case bottom
}

class DestinationRootPullUpViewContoller: PullUpController {
    
    // MARK: - Public Properties

    var initialPointOffset: CGFloat {
        return 0
    }
    // MARK: PullUpContollerNavigated
    
    // MARK: - Private Properties
    
    var _position: DestinationPullUpPosition = .bottom
    var _isInteractable: Bool = true
        
    // MARK: - Private funcs
    
    var _portraitSize: CGSize {
        return CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                      height: contentHeightFor(position: .top))
    }
    var _landscapeFrame: CGRect {
        return CGRect(x: 5, y: 50, width: 280, height: 300)
    }
    
    var mapPositionToHeight: [DestinationPullUpPosition: CGFloat] {
        return [:]
    }
    
    func contentHeightFor(position: DestinationPullUpPosition) -> CGFloat {
        if let height = mapPositionToHeight[position] {
            return height
        } else {
            return 0
        }
    }
    
    func positionFor(contentHeight: CGFloat) -> DestinationPullUpPosition? {
        if let key = mapPositionToHeight.allKeys(forValue: contentHeight).first {
            return key
        } else {
            return nil
        }
    }
    
    func scrollTo(position: DestinationPullUpPosition) {
        let contentHeight = contentHeightFor(position: position)
        pullUpControllerMoveToVisiblePoint(contentHeight,
                                           animated: true,
                                           completion: nil)
    }
    
    func updateAccordingTo(position: DestinationPullUpPosition) {
    }
        
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return _portraitSize
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return _landscapeFrame
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [contentHeightFor(position: .bottom), contentHeightFor(position: .middle)]
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }
    
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        switch action {
        case .move:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        default:
            UIView.animate(withDuration: 0.3,
                           animations: animations,
                           completion: completion)
        }
    }
    
    override func pullUpControllerDidMove(to point: CGFloat) {
        super.pullUpControllerDidMove(to: point)
        
        guard let newPosition = positionFor(contentHeight: point) else {return}
        _position = newPosition
        
        updateAccordingTo(position: _position)
    }
        
    // MARK: - PullUpContollerNavigated
    
    func pullUpControllerDidHide() {
        _isInteractable = false
    }
    
    func pullUpControllerDidGetBack() {
        _isInteractable = true
    }
    
    func closeForInteraction() {
        _isInteractable = false
    }
}
