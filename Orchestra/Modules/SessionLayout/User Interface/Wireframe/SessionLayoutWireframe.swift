//
//  SessionLayoutWireframe.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import UIKit

class SessionLayoutWireframe {
    
    var id: Int?
    weak var view: UIViewController!
    private lazy var instrumentDetailsWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var playerDetailWireframe: PlayerWireframeInput = {PlayerWireframe()}()

}

extension SessionLayoutWireframe: SessionLayoutWireframeInput {
    
    var storyboardName: String {return "SessionLayout"}
    
    func getMainView() -> UIViewController {
        let service = SessionLayoutService()
        let interactor = SessionLayoutInteractor(service: service)
        interactor.id = id
        let presenter = SessionLayoutPresenter()
        let viewController = SessionLayoutViewController()
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openInstrumentDetails(of id: Int?, musicianId: Int?) {
        instrumentDetailsWireframe.id = id
        instrumentDetailsWireframe.orchestraId = self.id
        instrumentDetailsWireframe.musicianId = musicianId
        instrumentDetailsWireframe.pushMainView(on: view)
    }
    
    func openPreviousModule() {
        view.navigationController?.popViewController(animated: false)
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
    func openMusicianDetail(of id: Int) {
        playerDetailWireframe.id = id
        playerDetailWireframe.pushMainView(on: view)
    }
    
}
