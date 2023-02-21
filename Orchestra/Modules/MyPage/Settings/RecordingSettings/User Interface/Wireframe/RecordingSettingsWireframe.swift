//
//  RecordingSettingsWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class RecordingSettingsWireframe {
    
    weak var view: UIViewController!
    
}

extension RecordingSettingsWireframe: RecordingSettingsWireframeInput {
    
    var storyboardName: String {return "RecordingSettings"}
    
    func getMainView() -> UIViewController {
        let service = RecordingSettingsService()
        let interactor = RecordingSettingsInteractor(service: service)
        let presenter = RecordingSettingsPresenter()
        let screen = RecordingSettingsScreen()
        let viewController = RecordingSettingsViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
