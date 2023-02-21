//
//  HallSoundDetailWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

import UIKit

class HallSoundDetailWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var buyWireframe: BuyWireframeInput = {BuyWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var sessionLayoutWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var playerListingWireframe: OrchestraPlayerListWireframeInput = {OrchestraPlayerListWireframe()}()
    
}

extension HallSoundDetailWireframe: HallSoundDetailWireframeInput {
    
    var storyboardName: String {return "HallSoundDetail"}
    
    func getMainView() -> UIViewController {
        let service = HallSoundDetailService()
        let interactor = HallSoundDetailInteractor(service: service)
        interactor.id = id
        let presenter = HallSoundDetailPresenter()
        presenter.id = id
        let screen = HallSoundDetailScreen()
        let viewController = HallSoundDetailViewController(baseScreen: screen)
        
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
    
    func openBuy() {
        buyWireframe.orchestraType = .hallSound
        buyWireframe.id = id
        let buyViewController = buyWireframe.getMainView()
        buyViewController.modalTransitionStyle = .crossDissolve
        buyViewController.modalPresentationStyle = .overCurrentContext
        view.tabBarController?.present(buyViewController, animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
        
    func openLogin(for mode: OpenMode?) {
        loginWireframe.openMode = mode
        if let tabBarController = view.tabBarController {
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
    func openOrchestraDetail(as type: OrchestraType) {
        switch type {
        case .conductor:
            conductorDetailWireframe.id = id
            conductorDetailWireframe.pushMainView(on: view)
        case .session:
            sessionLayoutWireframe.id = id
            sessionLayoutWireframe.pushMainView(on: view, animated: false)
        case .player:
            playerListingWireframe.id = id
            playerListingWireframe.pushMainView(on: view)
        case .hallSound:
            break
        }
    }
    
}
