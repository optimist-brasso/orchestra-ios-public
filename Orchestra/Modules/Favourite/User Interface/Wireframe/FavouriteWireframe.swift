//
//  FavouriteWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import UIKit

class FavouriteWireframe {
    
    weak var view: UIViewController!
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var conductorDetailsWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var hallsoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var playerWireframe: PlayerWireframeInput = {PlayerWireframe()}()
    private lazy var sessionLayoutWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var instrumentDetailWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    
}

extension FavouriteWireframe: FavouriteWireframeInput {
    
    var storyboardName: String {return "Favourite"}
    
    func getMainView() -> UIViewController {
        let service = FavouriteService()
        let interactor = FavouriteInteractor(service: service)
        let presenter = FavouritePresenter()
        let screen = FavouriteScreen()
        let viewController = FavouriteViewController(baseScreen: screen)
        viewController.tabBarItem = UITabBarItem(title: LocalizedKey.favourite.value, image: GlobalConstants.Image.TabBar.favourite, selectedImage: nil)
        
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
    
    func openDetails(of id: Int, type: OrchestraType) {
        switch type {
        case .conductor:
            conductorDetailsWireframe.id = id
            conductorDetailsWireframe.pushMainView(on: view)
        case .hallSound:
            hallsoundDetailWireframe.id = id
            hallsoundDetailWireframe.pushMainView(on: view)
        case .player:
            playerWireframe.id = id
            playerWireframe.pushMainView(on: view)
        case .session:
            sessionLayoutWireframe.id = id
            sessionLayoutWireframe.pushMainView(on: view, animated: false)
        }
    }
    
    func openInstrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?) {
        instrumentDetailWireframe.id = id
        instrumentDetailWireframe.orchestraId = orchestraId
        instrumentDetailWireframe.musicianId = musicianId
        instrumentDetailWireframe.pushMainView(on: view)
    }
    
}
