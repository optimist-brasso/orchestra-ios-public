//
//  SearchWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import UIKit

class SearchWireframe {
    
    weak var view: UIViewController!
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var conductorDetailsWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var hallsoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var sessionLayoutWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var instrumentDetailWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    
}

extension SearchWireframe: SearchWireframeInput {
    
    var storyboardName: String {return "Search"}
    
    func getMainView() -> UIViewController {
        let service = SearchService()
        let interactor = SearchInteractor(service: service)
        let presenter = SearchPresenter()
        let screen = SearchScreen()
        let viewController = SearchViewController(baseScreen: screen)
        viewController.tabBarItem = UITabBarItem(title: LocalizedKey.search.value, image: GlobalConstants.Image.TabBar.search, selectedImage: nil)
        
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
    
    func openOrchestraDetail(of id: Int?, type: OrchestraType) {
        switch type {
        case .conductor:
            conductorDetailsWireframe.id = id
            conductorDetailsWireframe.pushMainView(on: view)
        case .hallSound:
            hallsoundDetailWireframe.id = id
            hallsoundDetailWireframe.pushMainView(on: view)
        case .session:
            sessionLayoutWireframe.id = id
            sessionLayoutWireframe.pushMainView(on: view, animated: false)
        case .player:
            break
        }
    }
    
    func openInstrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?) {
        instrumentDetailWireframe.id = id
        instrumentDetailWireframe.orchestraId = orchestraId
        instrumentDetailWireframe.musicianId = musicianId
        instrumentDetailWireframe.pushMainView(on: view)
    }
    
}
