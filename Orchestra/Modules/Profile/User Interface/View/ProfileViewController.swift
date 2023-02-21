//
//  ProfileViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit


class ProfileViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: ProfileScreen  {
        baseScreen as! ProfileScreen
    }
    
    var presenter: ProfileModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    // MARK: Other Functions
    private func setup() {
        screen.editButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        presenter?.edit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: ProfileViewInterface
extension ProfileViewController: ProfileViewInterface {
    
    func show(_ model: ProfileViewModel) {
        screen.viewModel = model
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
