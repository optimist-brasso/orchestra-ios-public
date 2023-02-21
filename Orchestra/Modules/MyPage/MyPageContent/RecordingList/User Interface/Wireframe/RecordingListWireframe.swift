//
//  RecordingListWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class RecordingListWireframe {
    
    weak var view: UIViewController!
    private lazy var recordPlayerWireFrame: RecordPlayerWireframeInput = {RecordPlayerWireframe()}()
    
}

extension RecordingListWireframe: RecordingListWireframeInput {
    
    var storyboardName: String {return "RecordingList"}
    
    func getMainView() -> UIViewController {
        let service = RecordingListService()
        let interactor = RecordingListInteractor(service: service)
        let presenter = RecordingListPresenter()
        let screen = RecordingListScreen()
        let viewController = RecordingListViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openRecordPlayer() {
        let viewController = LightNavigationController(rootViewController: recordPlayerWireFrame.getMainView())
        view.presentFullScreen(viewController, animated: false)
    }
    
}
