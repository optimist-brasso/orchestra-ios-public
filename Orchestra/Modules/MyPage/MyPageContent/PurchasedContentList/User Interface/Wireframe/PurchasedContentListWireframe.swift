//
//  PurchasedContentListWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class PurchasedContentListWireframe {
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var hallsoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var instrumentDetailWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    private lazy var premiumVideoWireframe: PremiumVideoDetailsWireframeInput = {PremiumVideoDetailsWireframe()}()
    
    weak var view: UIViewController!
    
}

extension PurchasedContentListWireframe: PurchasedContentListWireframeInput {
    

    
    var storyboardName: String {return "PurchasedContentList"}
    
    func getMainView() -> UIViewController {
        let service = PurchasedContentListService()
        let interactor = PurchasedContentListInteractor(service: service)
        let presenter = PurchasedContentListPresenter()
        let screen = PurchasedContentListScreen()
        let viewController = PurchasedContentListViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openConductor(id: Int) {
        conductorDetailWireframe.id = id
        if let parentViewController = (view.parent?.parent as? MyPageViewController) {
            conductorDetailWireframe.pushMainView(on: parentViewController, animated: true)
            return
        }
        let navigationController = LightNavigationController(rootViewController: conductorDetailWireframe.getMainView())
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
    }
    
    func openHallSound(id: Int) {
        hallsoundDetailWireframe.id = id
        if let parentViewController = (view.parent?.parent as? MyPageViewController) {
            hallsoundDetailWireframe.pushMainView(on: parentViewController, animated: true)
            return
        }
        let navigationController = LightNavigationController(rootViewController: hallsoundDetailWireframe.getMainView())
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
    }
    
    
    func openPartDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?) {
        instrumentDetailWireframe.id = instrumentId
        instrumentDetailWireframe.orchestraId = orchestraId
        instrumentDetailWireframe.musicianId = musicianId
        if let parentViewController = (view.parent?.parent as? MyPageViewController) {
            instrumentDetailWireframe.pushMainView(on: parentViewController, animated: true)
            return
        }
        let navigationController = LightNavigationController(rootViewController: instrumentDetailWireframe.getMainView())
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
    }
    
    func openPremiumDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?) {
        premiumVideoWireframe.orchestraId = orchestraId
        premiumVideoWireframe.instrumentId = instrumentId
        premiumVideoWireframe.musicianId = musicianId
        if let parentViewController = (view.parent?.parent as? MyPageViewController) {
            premiumVideoWireframe.pushMainView(on: parentViewController, animated: true)
            return
        }
        let controller = premiumVideoWireframe.getMainView()
        let navigationController = LightNavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
    }
    
}
