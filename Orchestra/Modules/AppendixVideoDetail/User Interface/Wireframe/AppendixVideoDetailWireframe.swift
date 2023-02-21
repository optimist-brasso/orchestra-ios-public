//
//  AppendixVideoDetailWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

import UIKit

class AppendixVideoDetailWireframe {
    
    weak var view: UIViewController!
    var orchestraId: Int?
    var musicianId: Int?
    var instrumentId: Int?
   
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var instrumentPlayerWireframe: InstrumentPlayerWireframeInput = {InstrumentPlayerWireframe()}()
    private lazy var instrumentBuyWireframe: InstrumentDetailBuyWireframeInput = {InstrumentDetailBuyWireframe()}()
    
}

extension AppendixVideoDetailWireframe: AppendixVideoDetailWireframeInput {
    
    var storyboardName: String {return "AppendixVideoDetail"}
    
    func getMainView() -> UIViewController {
        let service = AppendixVideoDetailService()
        let interactor = AppendixVideoDetailInteractor(service: service)
        
        interactor.musicianId = musicianId
        interactor.instrumentId = instrumentId
        interactor.orchestraId = orchestraId
        
        let presenter = AppendixVideoDetailPresenter()
        let screen = AppendixVideoDetailScreen()
        let viewController = AppendixVideoDetailViewController(baseScreen: screen)
        
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
    
    func openPreviousModule() {
//        if let index = view.navigationController?.viewControllers.lastIndex(where: {$0 is InstrumentDetailViewController}),
//           let viewController = view.navigationController?.viewControllers.element(at: index) {
//            view.navigationController?.popToViewController(viewController, animated: true)
//        }
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
    
    func openVideoPlayer() {
        guard view.isTopViewController && view.tabBarController?.presentedViewController == nil else { return }
        instrumentPlayerWireframe.sessionType = .premium
        instrumentPlayerWireframe.orchestraId = orchestraId
        instrumentPlayerWireframe.isAppendixVideo = true
        instrumentPlayerWireframe.pushMainView(on: view, animated: false)
    }
    
//    func openVR() {
//        if let vc  = UIStoryboard.init(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController {
//            view.tabBarController?.presentFullScreen(vc, animated: false)
//        }
//    }
    
    func openBuy(for type: SessionType) {
        instrumentBuyWireframe.orchestraId = orchestraId
        instrumentBuyWireframe.type = type
        if let tabBarController = view.tabBarController {
            tabBarController.present(instrumentBuyWireframe.getMainView(), animated: true)
            return
        }
        view.present(instrumentBuyWireframe.getMainView(), animated: true)
    }
    
}
