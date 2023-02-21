//
//  StreamingDownloadSettingsWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class StreamingDownloadSettingsWireframe {
    
    weak var view: UIViewController!
    
}

extension StreamingDownloadSettingsWireframe: StreamingDownloadSettingsWireframeInput {
    
    var storyboardName: String {return "StreamingDownloadSettings"}
    
    func getMainView() -> UIViewController {
        let service = StreamingDownloadSettingsService()
        let interactor = StreamingDownloadSettingsInteractor(service: service)
        let presenter = StreamingDownloadSettingsPresenter()
        let screen = StreamingDownloadSettingsScreen()
        let viewController = StreamingDownloadSettingsViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
}
