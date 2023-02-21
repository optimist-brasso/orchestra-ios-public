//
//  PointHistoryWireframe.swift
//  Orchestra
//
//  Created by manjil on 13/12/2022.
//

import UIKit


protocol PointHistoryWireframeInput: WireframeInput {
    
}

class PointHistoryWireframe {
    
     weak var view: UIViewController!
    
}

extension PointHistoryWireframe: PointHistoryWireframeInput {
    
    var storyboardName: String {return ""}
    
    func getMainView() -> UIViewController {
        let service = BillingHistoryService()
        let interactor = PointHistoryInteractor(service: service)
        let presenter = PointHistoryPresenter()
        let viewController = PointHistoryController()
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
