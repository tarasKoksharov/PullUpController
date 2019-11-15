import Foundation
import UIKit

protocol DirectionsDisplayProtocol: AnyObject {
    func display(viewModel: DirectionsModels.ViewModel)
    func displayDisableDirections()
    func displayError(message: String)
}

class DirectionsViewContoller: DestinationRootPullUpViewContoller, DirectionsDisplayProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var titleContainerView: UIView! {
        didSet {
            titleContainerView.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.layer.cornerRadius = separatorView.frame.height/2
        }
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    @IBOutlet weak var vBody: UIView!
    @IBOutlet weak var vBodyContent: UIStackView!
    
    @IBOutlet weak var controlDirections: UIControl!
    @IBOutlet weak var lbBtnDirectionsTitle: UILabel!
    @IBOutlet weak var lbBtnDirectionsSubtitle: UILabel!
    
    @IBOutlet weak var lbBodyTitle: UILabel!
    @IBOutlet weak var lbBodyText: UILabel!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    // MARK: - Public Properties
    
    override var initialPointOffset: CGFloat {
        return 126//vBody.frame.height
    }
    
    // MARK: - Private Properties
    
    private var _presenter: DirectionsPresenterProtocol!
    
    // MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        updateUI()
                
        _presenter.presentDirections()
        activity.isHidden = false
    }
    
    // MARK: - Action
    @IBAction func clickClose(_ sender: Any) {
        _presenter.presentClose()
        activity.isHidden = true
    }
    
    @IBAction func clickDirections(_ sender: Any) {
        _presenter.presentSelectDirection()
        activity.isHidden = true
    }
    // MARK: - Public funcs:
    
    func setup(configurator: DirectionsConfiguratorProtocol) {
        _presenter = configurator.configure(self)
    }
    
    // MARK: - Private funcs
    
    private func makeUI() {
        self.lbTitle?.text = ""
        self.lbSubTitle?.text = ""
        
        self.lbBtnDirectionsSubtitle?.text = ""
        
        self.lbBodyText?.text = ""
    }
    
    private func updateUI() {
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
        }
    }
    
    override  var _portraitSize: CGSize {
        return CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                      height: contentHeightFor(position: .middle))
    }
    override  var _landscapeFrame: CGRect {
        return CGRect(x: 5, y: 50, width: 280, height: 300)
    }
    
    private var positionToHeight: [DestinationPullUpPosition: CGFloat] {
        
        print("tka vBodyContent.frame.height \(vBodyContent.frame.height)")
        
        guard let parent = parent else {return [:]}
        return [
            .top: parent.view.frame.height - (parent.view.safeAreaInsets.top + parent.view.safeAreaInsets.bottom + 20),
            .middle: 66 + vBodyContent.frame.height,
            .bottom: 66
        ]
    }
    
    override var mapPositionToHeight: [DestinationPullUpPosition: CGFloat] {
//        print("tka positionToHeight \(positionToHeight)")
        return positionToHeight
    }
    
    // MARK: - PullUpController
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [contentHeightFor(position: .bottom), contentHeightFor(position: .middle)]
    }
    
    // MARK: - Logic
    
    func display(viewModel: DirectionsModels.ViewModel) {
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
                        
            self.lbTitle?.text = viewModel.titleAddress
            self.lbSubTitle?.text = viewModel.subtitleAddress
            
            self.controlDirections?.isEnabled = true
            self.lbBtnDirectionsSubtitle?.text = viewModel.expetedTime
            
            self.lbBodyText?.text = viewModel.bodyAddress
            
            self.activity.isHidden = true
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Overriden funcs

    override func pullUpControllerDidGetBack() {
        super.pullUpControllerDidGetBack()
        _presenter.presentSearchedState()
    }
    
    func displayDisableDirections() {
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
            
            self.controlDirections?.isEnabled = false
            
            self.activity.isHidden = true
        }
    }
    
    func displayError(message: String) {
        self.activity.isHidden = true
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
}
