//
//  MyPageWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import UIKit

class MyPageWireframe {
    
    weak var view: UIViewController!
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    
}

extension MyPageWireframe: MyPageWireframeInput {

    var storyboardName: String {return "MyPage"}
    
    func getMainView() -> UIViewController {
        let service = MyPageService()
        let interactor = MyPageInteractor(service: service)
        let presenter = MyPagePresenter()
        let viewController = viewControllerFromStoryboard(of: MyPageViewController.self)
        viewController.tabBarItem = UITabBarItem(title: LocalizedKey.myPage.value, image: GlobalConstants.Image.TabBar.profile, selectedImage: nil)
        viewController.pagerTabStripViewController = viewControllers
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    var viewControllers: [UIViewController] {
        let myPageViewController = MyPageContentNavigationBarController(rootViewController: MyPageContentWireframe().getMainView())
        let settingsViewController = MyPageSettingsNavigationBarController(rootViewController: SettingsWireframe().getMainView())
        let moreViewController = MyPageMoreNavigationBarController(rootViewController: MoreWireframe().getMainView())
        
        return [myPageViewController,
                settingsViewController,
                moreViewController]
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
}
