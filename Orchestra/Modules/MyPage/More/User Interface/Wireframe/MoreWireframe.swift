//
//  MoreWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class MoreWireframe {
    
    weak var view: UIViewController!
    private lazy var onboardingWireframe: OnboardingWireframeInput = {OnboardingWireframe()}()
    private lazy var aboutAppWireFrame: AboutAppWireframeInput = {AboutAppWireframe()}()
    private lazy var faqWireFrame: FAQWireframeInput = {FAQWireframe()}()
    private lazy var opinionRequestWireFrame: OpinionRequestWireframeInput = {OpinionRequestWireframe()}()
    private lazy var officialSiteWireFrame: OfficialSiteWireframeInput = {OfficialSiteWireframe()}()
}

extension MoreWireframe: MoreWireframeInput {
    
    var storyboardName: String {return "More"}
    
    func getMainView() -> UIViewController {
        let service = MoreService()
        let interactor = MoreInteractor(service: service)
        let presenter = MorePresenter()
        let screen = MoreScreen()
        let viewController = MoreViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openOnboarding() {
        let wireframe = OnboardingWireframe(isCancellable: true)
        wireframe.openRegister = { [weak self] in
            self?.view.navigationController?.dismiss(animated: true)
        }
        view.navigationController?.presentFullScreen(LightNavigationController(rootViewController: wireframe.getMainView()), animated: true)
//        if let onboardingViewController = wireframe.getMainView() as? OnboardingViewController {
//            onboardingViewController.isCancellable = true
//            view.navigationController?.presentFullScreen(LightNavigationController(rootViewController: onboardingViewController), animated: true)
//        }
    }
    
    func navigateToAboutApp() {
        aboutAppWireFrame.pushMainView(on: view)
    }
    
    
    func navigateToFAQ() {
        faqWireFrame.pushMainView(on: view)
    }
    
    func navigateToOpinionRequest() {
        opinionRequestWireFrame.pushMainView(on: view)
    }
    
    func navigateToOfficialSite() {
        officialSiteWireFrame.pushMainView(on: view)
    }
    
    func openWebView(title: String?, url: String?) {
        let viewController = WebViewViewController(title: title, url: url)
        let navigationController = LightNavigationController(rootViewController: viewController)
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController.modalPresentationStyle = .fullScreen
        }
        view.tabBarController?.present(navigationController, animated: true)
    }
    
}

class MyPageMoreNavigationBarController: UINavigationController, IndicatorInfoProvider  {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedKey.more.value, image: GlobalConstants.Image.more, highlightedImage: nil, userInfo: false)
    }
    
}
