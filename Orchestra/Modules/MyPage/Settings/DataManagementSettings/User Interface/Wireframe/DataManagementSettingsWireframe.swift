//
//  DataManagementSettingsWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class DataManagementSettingsWireframe {
    
    weak var view: UIViewController!
    
}

extension DataManagementSettingsWireframe: DataManagementSettingsWireframeInput {
    
    var storyboardName: String {return "DataManagementSettings"}
    
    func getMainView() -> UIViewController {
        let service = DataManagementSettingsService()
        let interactor = DataManagementSettingsInteractor(service: service)
        let presenter = DataManagementSettingsPresenter()
        let screen = DataManagementSettingsScreen()
        let viewController = DataManagementSettingsViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
