//
//  HomeWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import UIKit

class HomeWireframe {
    
    weak var view: UIViewController!
    private lazy var orchestraListingWireframe: OrchestraListingWireframeInput = {OrchestraListingWireframe()}()
    private lazy var playerListingWireframe: PlayerListingWireframeInput = {PlayerListingWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var notificationDetailWireframe: NotificationDetailWireframeInput = {NotificationDetailWireframe()}()
    
}

extension HomeWireframe: HomeWireframeInput {
    
    var storyboardName: String {return "Home"}
    
    func getMainView() -> UIViewController {
        let service = HomeService()
        let interactor = HomeInteractor(service: service)
        let presenter = HomePresenter()
        let screen = HomeScreen()
        let viewController = HomeViewController(baseScreen: screen)
        viewController.tabBarItem = UITabBarItem(title: LocalizedKey.home.value, image: GlobalConstants.Image.TabBar.home, selectedImage: nil)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openHomeListing(of type: OrchestraType) {
        if type == .player {
            playerListingWireframe.pushMainView(on: view, animated: false)
            return
        }
        orchestraListingWireframe.pageOption = type
        orchestraListingWireframe.pushMainView(on: view, animated: false)
    }
    
    func openNotification() {
        notificationDetailWireframe.isNotificationDetail = true
        notificationWireframe.pushMainView(on: view)
    }
    
    func openBannerDetails(for url: String?) {
        if let url = URL(string: url ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return
        }
        notificationDetailWireframe.isNotificationDetail = false
        notificationDetailWireframe.pushMainView(on: view)
//        if let description = description {
//            view.alert(message: description)
//        }
    }
    
    func openDetails(of id: Int?) {
        conductorDetailWireframe.id = id
        conductorDetailWireframe.pushMainView(on: view)
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
