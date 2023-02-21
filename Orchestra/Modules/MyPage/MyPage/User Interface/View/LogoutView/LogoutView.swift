//
//  LogoutView.swift
//  Orchestra
//
//  Created by rohit lama on 18/05/2022.
//

import UIKit

class LogoutView: UIView {
    
    //MARK: - Properties
    var logout: (()->())?
    var closeView: (()->())?
    var isLoggedOut = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var logoutConfirmationLabel: UILabel?
    @IBOutlet weak var loggedOutLabel: UILabel?
    @IBOutlet weak var logoutButton: UIButton?
    @IBOutlet weak var cancelButton: UIButton?
    @IBOutlet weak var cancelStackView: UIStackView?
    
    //MARK: - LifeCycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(userLogoutSuccess), name: Notification.userLoggedOut, object: nil)
        setup()
    }
    
    //MARK: - Setup Functions
    func setup() {
        setupLabels()
        setupViews()
    }

    private func setupLabels() {
        loggedOutLabel?.isHidden = true
        logoutConfirmationLabel?.text = LocalizedKey.logoutConfirmation.value
        loggedOutLabel?.text = LocalizedKey.logoutValid.value
        cancelButton?.setTitle(LocalizedKey.cancel.value, for: .normal)
        logoutButton?.setTitle(LocalizedKey.yes.value, for: .normal)
    }

    private func setupViews() {
        layer.cornerRadius = 10
        logoutButton?.layer.cornerRadius = 5
    }
    
    //MARK: - IBActions
    @IBAction func crossButtonTapped(_ sender: Any) {
        if !isLoggedOut {
            closeView?()
        } else {
            NotificationCenter.default.post(name: Notification.logoutSuccess, object: nil)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
       logout?()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        closeView?()
    }
    
    @objc private func userLogoutSuccess() {
        [logoutConfirmationLabel, logoutButton, cancelStackView].forEach({
            $0?.isHidden = true
        })
        loggedOutLabel?.isHidden = false
        isLoggedOut = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
