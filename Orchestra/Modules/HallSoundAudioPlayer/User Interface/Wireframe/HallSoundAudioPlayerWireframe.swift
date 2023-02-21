//
//  HallSoundAudioPlayerWireframe.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

import UIKit


class HallSoundAudioPlayerWireframe {
    
     weak var view: UIViewController!
    
}

extension HallSoundAudioPlayerWireframe: HallSoundAudioPlayerWireframeInput {
    
    var storyboardName: String {return "HallSoundAudioPlayer"}
    
    func getMainView() -> UIViewController {
        let service = HallSoundAudioPlayerService()
        let interactor = HallSoundAudioPlayerInteractor(service: service)
        let presenter = HallSoundAudioPlayerPresenter()
        let viewController = viewControllerFromStoryboard(of: HallSoundAudioPlayerViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
        
    }
    
}
