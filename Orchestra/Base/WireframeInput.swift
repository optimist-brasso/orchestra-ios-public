//
//  WireframeInput.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import UIKit.UIWindow

public protocol WireframeInput {
    
    var window: UIWindow? { get }
    var view: UIViewController! { get }
    var storyboardName: String { get }
    func openMainView(source: UIViewController)
    func pushMainView(on source: UIViewController, animated: Bool)
    func pushMainView(in source: UINavigationController)
    func getMainView() -> UIViewController
    func openMainViewIn(window: UIWindow)
    func openViewControllerWithNavigation(source: UIViewController)
    
}

public extension WireframeInput {
    
    var window: UIWindow? {
        return UIApplication.shared.delegate?.window ?? UIWindow()
    }
    
    func viewControllerFromStoryboard<T: UIViewController>(of type: T.Type) -> T {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    func openMainViewIn(window: UIWindow) {
        let view = getMainView()
        window.rootViewController = view
    }
    
    func openMainViewAsNavigationControllerIn(window: UIWindow) {
        let view = getMainView()
        let nav = UINavigationController.init(rootViewController: view)
        window.rootViewController = nav
    }
    
    func openMainView(source: UIViewController) {
        let mainView = getMainView()
        mainView.modalPresentationStyle = .fullScreen
        source.present(mainView, animated: true, completion: nil)
    }
    
    func pushMainView(on source: UIViewController, animated: Bool = true) {
        let mainView = getMainView()
        source.navigationController?.pushViewController(mainView, animated: animated)
    }
    
    func pushMainView(in source: UINavigationController) {
        let mainView = getMainView()
        source.pushViewController(mainView, animated: true)
    }
    
    func openViewControllerWithNavigation(source: UIViewController) {
        let nav = UINavigationController(rootViewController: getMainView())
        nav.modalPresentationStyle = .fullScreen
        source.present(nav, animated: true, completion: nil)
    }
    
    func openViewControllerWithNavigationOverFullScreen(viewController: UIViewController, source: UIViewController) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .overFullScreen
        source.present(nav, animated: false, completion: nil)
    }
    
}
