//
//  MyPageContentWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class MyPageContentWireframe: BaseWireframe {
    
    //weak var view: UIViewController!
    private lazy var purchasedContentListWireframe: PurchasedContentListWireframeInput = {PurchasedContentListWireframe()}()
    private lazy var recordingListWireframe: RecordingListWireframeInput = {RecordingListWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var billingHistoryWireframe: BillingHistoryWireframeInput = {BillingHistoryWireframe()}()
    private lazy var pointHistoryWireframe: PointHistoryWireframeInput = {PointHistoryWireframe()}()
    private lazy var withdrawWireframe: WithdrawWireframeInput = {WithdrawWireframe()}()
    private lazy var buyPointWireframe: BuyPointWireframeInput = {BuyPointWireframe()}()
    
    override var storyboardName: String {
        return "MyPageContent"
    }
    
    override func setViewController() {
        let service = MyPageContentService()
        let interactor = MyPageContentInteractor(service: service)
        let presenter = MyPageContentPresenter()
        let screen = MyPageContentScreen()
        let viewController = MyPageContentViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
    }
}

extension MyPageContentWireframe: MyPageContentWireframeInput {
    
    func openProfile() {
        let wireframe = ProfileWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    func openPurchasedContentList() {
        purchasedContentListWireframe.pushMainView(on: view)
    }
    
    func openRecordingList() {
        recordingListWireframe.pushMainView(on: view)
    }
    
    func openLogin() {
//        if let tabBarController = view.tabBarController {
//            loginWireframe.openViewControllerWithNavigation(source: tabBarController)
//        }
        NotificationCenter.default.post(name: Notification.logOut, object: nil)
    }
    
    func openChangePassword() {
        let wireframe = ChangePasswordWireframe(service: ChangePasswordService())
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    func openBillingHistory() {
        pointHistoryWireframe.pushMainView(on: view)
    }
    
    func openWithdraw() {
        withdrawWireframe.pushMainView(on: view)
    }
    
    func openBuyPoint() {
        let controller = buyPointWireframe.getMainView()
        let navigationController = LightNavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
        
        //buyPointWireframe.pushMainView(on: view)
    }
    
}

class MyPageContentNavigationBarController: UINavigationController, IndicatorInfoProvider  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedKey.myPage.value, image: GlobalConstants.Image.profile, highlightedImage: nil, userInfo: false)
    }
    
}
