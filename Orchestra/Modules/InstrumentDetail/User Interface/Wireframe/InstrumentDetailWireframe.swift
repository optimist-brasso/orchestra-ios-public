//
//  InstrumentDetailWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

import UIKit

class InstrumentDetailWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    var orchestraId: Int?
    var musicianId: Int?
    private lazy var bulkInstrumentPurchaseWireframe: BulkInstrumentPurchaseWireframeInput = {BulkInstrumentPurchaseWireframe()}()
    private lazy var instrumentBuyWireframe: InstrumentDetailBuyWireframeInput = {InstrumentDetailBuyWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var premiumVideoWireframe: PremiumVideoDetailsWireframeInput = {PremiumVideoDetailsWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var hallSoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var playerListWireframe: OrchestraPlayerListWireframeInput = {OrchestraPlayerListWireframe()}()
    private lazy var appendixVideoDetailWireframe: AppendixVideoDetailWireframeInput = {AppendixVideoDetailWireframe()}()
    private lazy var instrumentPlayerWireframe: InstrumentPlayerWireframeInput = {InstrumentPlayerWireframe()}()
    
}

extension InstrumentDetailWireframe: InstrumentDetailWireframeInput {
    
    var storyboardName: String {return "InstrumentDetail"}
    
    func getMainView() -> UIViewController {
        let service = InstrumentDetailService()
        let interactor = InstrumentDetailInteractor(service: service)
        interactor.id = id
        interactor.orchestraId = orchestraId
        interactor.musicianId = musicianId
        let presenter = InstrumentDetailPresenter()
        presenter.id = id
        presenter.orchestraId = orchestraId
        presenter.musicianId = musicianId
        let screen = InstrumentDetailScreen()
        let viewController = InstrumentDetailViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openPreviousModule() {
        view.navigationController?.popViewController(animated: false)
    }
    
    func openBulkPurchase() {
        bulkInstrumentPurchaseWireframe.id = orchestraId
        bulkInstrumentPurchaseWireframe.instrumentId = id
        bulkInstrumentPurchaseWireframe.musicianId = musicianId
        bulkInstrumentPurchaseWireframe.bulkType = .part
        bulkInstrumentPurchaseWireframe.pushMainView(on: view)
    }
    
    func openBuy() {
        instrumentBuyWireframe.orchestraId = orchestraId
        instrumentBuyWireframe.type = .part
        view.tabBarController?.present(instrumentBuyWireframe.getMainView(), animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openPremiumVideo() {
        premiumVideoWireframe.instrumentId = id
        premiumVideoWireframe.musicianId = musicianId
        premiumVideoWireframe.orchestraId = orchestraId
        premiumVideoWireframe.pushMainView(on: view)
    }
    
    func openLogin() {
        if let tabBarController = view.tabBarController {
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
    func openOrchestraDetails(as type: OrchestraType) {
        switch type {
        case .conductor:
            conductorDetailWireframe.id = orchestraId
            conductorDetailWireframe.pushMainView(on: view)
        case .hallSound:
            hallSoundDetailWireframe.id = orchestraId
            hallSoundDetailWireframe.pushMainView(on: view)
        case .player:
            playerListWireframe.id = orchestraId
            playerListWireframe.pushMainView(on: view)
        case .session:
            break
        }
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
    
    func openVR() {
        guard view.isTopViewController else { return }
        instrumentPlayerWireframe.sessionType = .part
        instrumentPlayerWireframe.pushMainView(on: view, animated: false)
//        if let vc  = UIStoryboard(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController {
//            if let tabBarController = view.tabBarController {
//                tabBarController.presentFullScreen(vc, animated: false)
//                return
//            }
//            view.presentFullScreen(vc, animated: false)
//        }
    }
    
    func openAppendixVideo() {
        appendixVideoDetailWireframe.orchestraId = orchestraId
        appendixVideoDetailWireframe.musicianId = musicianId
        appendixVideoDetailWireframe.instrumentId = id 
        appendixVideoDetailWireframe.pushMainView(on: view)
    }
    
}
