//
//  PlayerWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import UIKit

class PlayerWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var sessionDetailWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var instrumentDetailWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()

    
}

extension PlayerWireframe: PlayerWireframeInput {
    
    var storyboardName: String {return "Player"}
    
    func getMainView() -> UIViewController {
        let service = PlayerService()
        let interactor = PlayerInteractor(service: service)
        interactor.id = id
        let presenter = PlayerPresenter()
        presenter.id = id
        let screen = PlayerScreen()
        let viewController = PlayerViewController(baseScreen: screen)
        
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
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
    func openWebsite(of url: String?) {
        if let url = URL(string: url ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openIntrumentDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?, isMinusOne: Bool?) {
        instrumentDetailWireframe.id = instrumentId
        instrumentDetailWireframe.orchestraId = orchestraId
        instrumentDetailWireframe.musicianId = musicianId
        instrumentDetailWireframe.pushMainView(on: view)
    }
    
    func openConductorDetail(of id: Int?) {
        conductorDetailWireframe.id = id
        conductorDetailWireframe.pushMainView(on: view)
    }
    
}
