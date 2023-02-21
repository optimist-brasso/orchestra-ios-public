//
//  PremiumVideoDetailsWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class PremiumVideoDetailsWireframe {
    
    weak var view: UIViewController!
    var orchestraId: Int?
    var musicianId: Int?
    var instrumentId: Int?
    
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var instrumentBuyWireframe: InstrumentDetailBuyWireframeInput = {InstrumentDetailBuyWireframe()}()
    private lazy var bulkInstrumentPurchaseWireframe: BulkInstrumentPurchaseWireframeInput = {BulkInstrumentPurchaseWireframe()}()
    private lazy var appendixVideoDetailWireframe: AppendixVideoDetailWireframeInput = {AppendixVideoDetailWireframe()}()
    private lazy var instrumentPlayerWireframe: InstrumentPlayerWireframeInput = {InstrumentPlayerWireframe()}()
    
}

extension PremiumVideoDetailsWireframe: PremiumVideoDetailsWireframeInput {
    
    var storyboardName: String {return "PremiumVideoDetails"}
    
    func getMainView() -> UIViewController {
        let service = PremiumVideoDetailsService()
        let interactor = PremiumVideoDetailsInteractor(service: service)
        let presenter = PremiumVideoDetailsPresenter()
        let screen = PremiumVideoDetailsScreen()
        let viewController = PremiumVideoDetailsViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        interactor.orchestraId = orchestraId
        interactor.musicianId = musicianId
        interactor.instrumentId = instrumentId
        
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openPreviousModule() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openLogin() {
        if let tabBarController = view.tabBarController {
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
    func openBuy(for type: SessionType) {
        instrumentBuyWireframe.orchestraId = orchestraId
        instrumentBuyWireframe.type = type
        if let tabBarController = view.tabBarController {
            tabBarController.present(instrumentBuyWireframe.getMainView(), animated: true)
            return
        }
        view.present(instrumentBuyWireframe.getMainView(), animated: true)
    }
    
    func openImageViewer(with imageUrl: String?) {
        if let url = URL(string: imageUrl ?? "") {
            let imageViewer = ImageViewerController(imageURL: url, placeHolder: GlobalConstants.Image.placeholder ?? UIImage(), name: "Organization Diagram", info: nil)
            if let tabBarController = view.tabBarController {
                tabBarController.presentFullScreen(imageViewer, animated: true)
                return
            }
            view.presentFullScreen(imageViewer, animated: true)
        }
    }
    
    func openBulkPurchase() {
        bulkInstrumentPurchaseWireframe.id = orchestraId
        bulkInstrumentPurchaseWireframe.musicianId = musicianId
        bulkInstrumentPurchaseWireframe.instrumentId = instrumentId
        bulkInstrumentPurchaseWireframe.bulkType = .combo
        bulkInstrumentPurchaseWireframe.pushMainView(on: view)
    }
    
    func openVR() {
        guard view.isTopViewController && view.tabBarController?.presentedViewController == nil else { return }
        instrumentPlayerWireframe.sessionType = .premium
        instrumentPlayerWireframe.pushMainView(on: view, animated: false)
    }
    
    func openAppendixVideo() {
        appendixVideoDetailWireframe.musicianId = musicianId
        appendixVideoDetailWireframe.instrumentId = instrumentId
        appendixVideoDetailWireframe.orchestraId = orchestraId
        appendixVideoDetailWireframe.pushMainView(on: view)
    }
    
}
