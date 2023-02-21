//
//  FAQWireframe.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import UIKit

class FAQWireframe {
    
    weak var view: UIViewController!
    
}

extension FAQWireframe: FAQWireframeInput {
    
    var storyboardName: String {return "FAQ"}
    
    func getMainView() -> UIViewController {
        let service = FAQService()
        let interactor = FAQInteractor(service: service)
        let presenter = FAQPresenter()
        let viewController = FAQViewController()
        
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
