//
//  BillingHistoryWireframe.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

import UIKit


class BillingHistoryWireframe {
    
     weak var view: UIViewController!
    
}

extension BillingHistoryWireframe: BillingHistoryWireframeInput {
    
    var storyboardName: String {return "BillingHistory"}
    
    func getMainView() -> UIViewController {
        let service = BillingHistoryService()
        let interactor = BillingHistoryInteractor(service: service)
        let presenter = BillingHistoryPresenter()
        let viewController = viewControllerFromStoryboard(of: BillingHistoryViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
