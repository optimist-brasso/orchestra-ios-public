//
//  InstrumentPlayerPopupWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class InstrumentPlayerPopupWireframe {
    
    weak var view: UIViewController!
    var sessionType: SessionType = .part
    var orchestraId: Int?
    var isAppendixVideo = false
    private lazy var bulkInstrumentPurchaseWireframe: BulkInstrumentPurchaseWireframeInput = {BulkInstrumentPurchaseWireframe()}()
    private lazy var instrumentPlayerWireframe: InstrumentPlayerWireframeInput = {InstrumentPlayerWireframe()}()
    
}

extension InstrumentPlayerPopupWireframe: InstrumentPlayerPopupWireframeInput {
    
    var storyboardName: String {return "InstrumentPlayerPopup"}
    
    func getMainView() -> UIViewController {
        let service = InstrumentPlayerPopupService()
        let interactor = InstrumentPlayerPopupInteractor(service: service)
        interactor.type = sessionType
        interactor.orchestraId = orchestraId
        let presenter = InstrumentPlayerPopupPresenter()
        let screen = InstrumentPlayerPopupScreen()
        screen.sessionType = sessionType
        screen.isAppendixVideo = isAppendixVideo
        let viewController = InstrumentPlayerPopupViewController(baseScreen: screen)
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
    
    func openBulkPurchase() {
        bulkInstrumentPurchaseWireframe.id = orchestraId
        (view.presentingViewController as? UINavigationController)?.pushViewController(bulkInstrumentPurchaseWireframe.getMainView(), animated: false)
        view.dismiss(animated: false)
    }
    
    func openPremiumVideoPlayer() {
        let navigationController = view.presentingViewController as? UINavigationController
        view.dismiss(animated: false)
        instrumentPlayerWireframe.sessionType = .premium
        instrumentPlayerWireframe.orchestraId = orchestraId
        navigationController?.pushViewController(instrumentPlayerWireframe.getMainView(), animated: false)
        navigationController?.viewControllers.remove(at: (navigationController?.viewControllers.count ?? .zero) - 2)
    }
    
    func openAppendixVideoPlayer() {
        let navigationController = view.presentingViewController as? UINavigationController
        view.dismiss(animated: false)
        instrumentPlayerWireframe.sessionType = .premium
        instrumentPlayerWireframe.orchestraId = orchestraId
        instrumentPlayerWireframe.isAppendixVideo = true
        navigationController?.pushViewController(instrumentPlayerWireframe.getMainView(), animated: false)
        navigationController?.viewControllers.remove(at: (navigationController?.viewControllers.count ?? .zero) - 2)
    }
    
}
