//
//  BaseNavigationController.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit
class BaseNavigationController: LightNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background//.withAlphaComponent(0.1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.navTitleColor, .font: UIFont.appFont(type: .system(.bold), size: .size17)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
       return true
    }
}
