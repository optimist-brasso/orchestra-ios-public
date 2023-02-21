//
//  InstrumentPlayerWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

import UIKit

class InstrumentPlayerWireframe {
    
    weak var view: UIViewController!
    var sessionType: SessionType = .premium
    var orchestraId: Int?
    var isAppendixVideo = false
    private lazy var instrumentPlayerPopupWireframe: InstrumentPlayerPopupWireframeInput = {InstrumentPlayerPopupWireframe()}()
    
}

extension InstrumentPlayerWireframe: InstrumentPlayerWireframeInput {
    
    var storyboardName: String {return "InstrumentPlayer"}
    
    func getMainView() -> UIViewController {
        let service = InstrumentPlayerService()
        let interactor = InstrumentPlayerInteractor(service: service)
        interactor.sessionType = sessionType
        interactor.isAppendixVideo = isAppendixVideo
        let presenter = InstrumentPlayerPresenter()
//        let screen = InstrumentPlayerScreen()
//        screen.sessionType = sessionType
//        screen.isAppendixVideo = isAppendixVideo
        let viewController = viewControllerFromStoryboard(of: InstrumentPlayerViewController.self)
        viewController.sessionType = sessionType
        viewController.orchestraId = orchestraId ?? .zero
        viewController.isPlayerNormal = isAppendixVideo
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openInstrumentPlayerPopup() {
        instrumentPlayerPopupWireframe.sessionType = sessionType
        instrumentPlayerPopupWireframe.orchestraId = orchestraId
        instrumentPlayerPopupWireframe.isAppendixVideo = isAppendixVideo
        view.present(instrumentPlayerPopupWireframe.getMainView(), animated: true)
    }
    
    func openPreviousModule() {
        view.navigationController?.popViewController(animated: false)
    }
    
}
