//
//  OrchestraListingWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class OrchestraListingWireframe {
    
    weak var view: UIViewController!
    var pageOption: OrchestraType?
    private lazy var orchestraListingWireframe: OrchestraListingWireframeInput = {OrchestraListingWireframe()}()
    private lazy var playerListingWireframe: PlayerListingWireframeInput = {PlayerListingWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var hallSoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var sessionLayoutWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    
}

extension OrchestraListingWireframe: OrchestraListingWireframeInput {
    
    var storyboardName: String {return "HomeListing"}
    
    func getMainView() -> UIViewController {
        let service = OrchestraListingService()
        let interactor = OrchestraListingInteractor(service: service)
        let presenter = OrchestraListingPresenter()
        let screen = OrchestraListingScreen()
        let viewController = OrchestraListingViewController(baseScreen: screen)
        viewController.pageOption = pageOption
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openOrchestraListing(of type: OrchestraType) {
        guard pageOption != type else { return }
        let navigationControllerStackCount = view.navigationController?.viewControllers.count ?? .zero
        if type == .player {
            playerListingWireframe.pushMainView(on: view, animated: false)
            view.navigationController?.viewControllers.remove(at: navigationControllerStackCount - 1)
            return
        }
        orchestraListingWireframe.pageOption = type
        orchestraListingWireframe.pushMainView(on: view, animated: false)
        view.navigationController?.viewControllers.remove(at: navigationControllerStackCount - 1)
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openOrchestraDetail(of id: Int?) {
        if let pageOption = pageOption {
            switch pageOption {
            case .conductor:
                conductorDetailWireframe.id = id
                conductorDetailWireframe.pushMainView(on: view)
            case .hallSound:
                hallSoundDetailWireframe.id = id
                hallSoundDetailWireframe.pushMainView(on: view)
            case .session:
                sessionLayoutWireframe.id = id
                sessionLayoutWireframe.pushMainView(on: view, animated: false)
            case .player:
                break;
            }
        }
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
}
