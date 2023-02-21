//
//  OpinionRequestWireframe.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/22/22.
//
//

import UIKit

class OpinionRequestWireframe {
    
    weak var view: UIViewController!
    
}

extension OpinionRequestWireframe: OpinionRequestWireframeInput {
    
    var storyboardName: String {return "OpinionRequest"}
    
    func getMainView() -> UIViewController {
        let service = OpinionRequestService()
        let interactor = OpinionRequestInteractor(service: service)
        let presenter = OpinionRequestPresenter()
        let viewController = OpinionRequestViewController()
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openWebView(title: String?, url: String?) {
        let viewController = WebViewViewController(title: title, url: url)
        let navigationController = LightNavigationController(rootViewController: viewController)
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController.modalPresentationStyle = .fullScreen
        }
        view.tabBarController?.present(navigationController, animated: true)
    }
    
}
