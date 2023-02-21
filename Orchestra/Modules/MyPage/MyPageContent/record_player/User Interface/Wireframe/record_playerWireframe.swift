//
//  record_playerWireframe.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import UIKit

class record_playerWireframe {
     weak var view: UIViewController!
}

extension record_playerWireframe: record_playerWireframeInput {
    
    var storyboardName: String {return "record_player"}
    
    func getMainView() -> UIViewController {
        let service = record_playerService()
        let interactor = record_playerInteractor(service: service)
        let presenter = record_playerPresenter()
        let viewController = viewControllerFromStoryboard(of: record_playerViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
}
