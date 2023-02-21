//
//  InstrumentBuyWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

import UIKit

class BulkInstrumentBuyConfirmationWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    var type: SessionType = .part
    var successState: Bool = false
    
}

extension BulkInstrumentBuyConfirmationWireframe: BulkInstrumentBuyConfirmationWireframeInput {
    
    
    var storyboardName: String {return "InstrumentBuy"}
    
    func getMainView() -> UIViewController {
        let service = BulkInstrumentBuyConfirmationService()
        let interactor = BulkInstrumentBuyConfirmationInteractor(service: service)
        interactor.id = id
        interactor.successState = successState
        interactor.sessionType = type
        let presenter = BulkInstrumentBuyConfirmationPresenter()
        let screen = BulkInstrumentBuyConfirmationScreen()
        let viewController = BulkInstrumentBuyConfirmationViewController(baseScreen: screen)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openPreviousModule() {
        view.dismiss(animated: true)
    }
    
}
