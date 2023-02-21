//
//  AboutAppWireframe.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import UIKit

class AboutAppWireframe {
    
    weak var view: UIViewController!
    
}

extension AboutAppWireframe: AboutAppWireframeInput {
    
    var storyboardName: String {return "AboutApp"}
    
    func getMainView() -> UIViewController {
        let service = AboutAppService()
        let interactor = AboutAppInteractor(service: service)
        let presenter = AboutAppPresenter()
        let viewController = AboutAppViewController()
        
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
        if  UIDevice.current.userInterfaceIdiom == .pad {
            navigationController.modalPresentationStyle = .fullScreen
        }
        view.tabBarController?.present(navigationController, animated: true)
    }
    
}
