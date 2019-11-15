import Foundation

protocol DirectionsPresenterProtocol {
    func presentDirections()
    func presentClose()
    func presentSelectDirection()
    func presentSearchedState()
}

class DirectionsPresenter: DirectionsPresenterProtocol {
    private weak var _view: DirectionsDisplayProtocol?
    private var _router: DirectionsRouterProtocol?
    
    // MARK: - Main
    
    init(view: DirectionsDisplayProtocol,
         router: DirectionsRouterProtocol?) {
        _view = view
        _router = router
    }
    
    // MARK: Logic
    
    func presentDirections() {
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let `self` = self else { return }
            self.test()
        }
    }
    
    func test() {
        let viewModel = DirectionsModels.ViewModel(titleAddress: "tes",
                                               subtitleAddress: "test",
                                               expetedTime: "test",
        bodyAddress: "sdfsdfasd asdlfhdsjfask asldfsdlkfjasdlkjf asdfajsdkfjasldf  asdfasdfasdf")
        
        _view?.display(viewModel: viewModel)
    }
    
    func presentClose() {
    }
    
    func presentSelectDirection() {
    }
    
    func presentSearchedState() {
    }
    
    // MARK: - Private funcs
}
