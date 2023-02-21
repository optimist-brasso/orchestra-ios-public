//
//  RecordPlayerWireframe.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import UIKit


class RecordPlayerWireframe {
    
     weak var view: UIViewController!
    
}

extension RecordPlayerWireframe: RecordPlayerWireframeInput {
    
    var storyboardName: String {return "RecordPlayer"}
    
    func getMainView() -> UIViewController {
        let service = RecordPlayerService()
        let interactor = RecordPlayerInteractor(service: service)
        let presenter = RecordPlayerPresenter()
        let viewController = viewControllerFromStoryboard(of: RecordPlayerViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
