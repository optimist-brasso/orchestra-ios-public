//
//  BulkInstrumentPurchaseWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import UIKit


class BulkInstrumentPurchaseWireframe {
    
    weak var view: UIViewController!
    var id: Int? //orchestraId
    var bulkType = SessionType.part
    var instrumentId: Int?
    var musicianId: Int?
    
    private lazy var instrumentBuyWireframe: BulkInstrumentBuyConfirmationWireframeInput = {BulkInstrumentBuyConfirmationWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    
}

extension BulkInstrumentPurchaseWireframe: BulkInstrumentPurchaseWireframeInput {
    
    var storyboardName: String {return "BulkInstrumentPurchase"}
    
    func getMainView() -> UIViewController {
        let service = BulkInstrumentPurchaseService()
        let interactor = BulkInstrumentPurchaseInteractor(service: service)
        interactor.id = id
        interactor.instrumentId = instrumentId
        interactor.musicianId = musicianId
        let presenter = BulkInstrumentPurchasePresenter()
        let screen = BulkInstrumentPurchaseScreen()
        let viewController = BulkInstrumentPurchaseViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        viewController.bulkType = bulkType
        interactor.output = presenter
        presenter.interactor = interactor
        interactor.type = bulkType
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openConfirmation() {
        instrumentBuyWireframe.id = id
        instrumentBuyWireframe.successState = false
        instrumentBuyWireframe.type = bulkType
        view.tabBarController?.present(instrumentBuyWireframe.getMainView(), animated: true)
    }
    
    func openPreviousModule() {
        let viewControllers = view.navigationController?.viewControllers ?? []
        view.navigationController?.popViewController(animated: !(viewControllers.element(at: viewControllers.count - 2) is InstrumentPlayerViewController))
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openSuccessView() {
        instrumentBuyWireframe.successState = true
        view.tabBarController?.present(instrumentBuyWireframe.getMainView(), animated: true)
    }
    
}
