//
//  InstrumentDetailBuyWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class InstrumentDetailBuyWireframe {
    
    weak var view: UIViewController!
    var orchestraId: Int?
    var type: SessionType?
    
}

extension InstrumentDetailBuyWireframe: InstrumentDetailBuyWireframeInput {
    
    var storyboardName: String {return "InstrumentDetailBuy"}
    
    func getMainView() -> UIViewController {
        let service = InstrumentDetailBuyService()
        let interactor = InstrumentDetailBuyInteractor(service: service)
        interactor.orchestraId = orchestraId
        interactor.type = type
        let presenter = InstrumentDetailBuyPresenter()
        let screen = InstrumentDetailBuyScreen()
        let viewController = InstrumentDetailBuyViewController(baseScreen: screen)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
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
