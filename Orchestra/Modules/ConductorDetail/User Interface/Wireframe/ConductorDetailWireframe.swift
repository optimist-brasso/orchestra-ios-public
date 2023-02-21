//
//  ConductorDetailWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import UIKit

class ConductorDetailWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var hallSoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var sessionLayoutWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var playerListingWireframe: OrchestraPlayerListWireframeInput = {OrchestraPlayerListWireframe()}()
    private lazy var instrumentPlayerWireframe: InstrumentPlayerWireframeInput = {InstrumentPlayerWireframe()}()
    
}

extension ConductorDetailWireframe: ConductorDetailWireframeInput {
    
    var storyboardName: String {return "ConductorDetail"}
    
    func getMainView() -> UIViewController {
        let service = ConductorDetailService()
        let interactor = ConductorDetailInteractor(service: service)
        interactor.id = id
        let presenter = ConductorDetailPresenter()
        presenter.id = id
        let screen = ConductorDetailScreen()
        let viewController = ConductorDetailViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openListing() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func openImageViewer(with imageUrl: String?) {
        if let url = URL(string: imageUrl ?? "") {
            let imageViewer = ImageViewerController(imageURL: url, placeHolder: GlobalConstants.Image.placeholder ?? UIImage(), name: "Organization Diagram", info: nil)
            view.tabBarController?.presentFullScreen(imageViewer, animated: true)
        }
    }

    func openOrchestraDetails(as type: OrchestraType) {
        switch type {
        case .session:
            sessionLayoutWireframe.id = id
            sessionLayoutWireframe.pushMainView(on: view, animated: false)
        case .hallSound:
            hallSoundDetailWireframe.id = id
            hallSoundDetailWireframe.pushMainView(on: view)
        case .player:
            playerListingWireframe.id = id
            playerListingWireframe.pushMainView(on: view)
        case .conductor:
            break
        }
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openVR() {
        guard view.isTopViewController && view.tabBarController?.presentedViewController == nil else { return }
        instrumentPlayerWireframe.sessionType = .part
        instrumentPlayerWireframe.pushMainView(on: view, animated: false)
//        if let vc = UIStoryboard(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController {
//            view.tabBarController?.presentFullScreen(vc, animated: false)
//        }
    }
    
}
