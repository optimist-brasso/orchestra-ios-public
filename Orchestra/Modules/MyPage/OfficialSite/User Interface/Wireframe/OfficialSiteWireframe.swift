//
//  OfficialSiteWireframe.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWALon 6/23/22.
//
//

import UIKit

class OfficialSiteWireframe {
     weak var view: UIViewController!
}

extension OfficialSiteWireframe: OfficialSiteWireframeInput {
    
    var storyboardName: String {return "OfficialSite"}
    
    func getMainView() -> UIViewController {
        let service = OfficialSiteService()
        let interactor = OfficialSiteInteractor(service: service)
        let presenter = OfficialSitePresenter()
        let viewController = OfficialSiteViewController()
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
}
