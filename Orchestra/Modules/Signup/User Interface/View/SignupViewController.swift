//
//  SignupViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {
    
    // MARK: Properties
    var presenter: SignupModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: IBActions
    @IBAction func buttonEmail(_ sender: Any) {
        presenter?.singupWithEmail()
    }
    
    @IBAction func buttonLine(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable == true {
            presenter?.singupWithLine()
        } else {
            showAlert(message: GlobalConstants.Error.noInternet.localizedDescription)
        }
    }
    
    @IBAction func buttonTwitter(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable == true {
//            presenter?.singupWithTwitter()
        } else {
            showAlert(message: GlobalConstants.Error.noInternet.localizedDescription)
        }
    }
    
    @IBAction func buttonFacebook(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable == true {
            presenter?.singupWithFacebook()
        } else {
            showAlert(message: GlobalConstants.Error.noInternet.localizedDescription)
        }
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        presenter?.login()
    }
    
    // MARK: Other Functions
    private func setup() {
        
    }
}

// MARK: SignupViewInterface
extension SignupViewController: SignupViewInterface {
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    
    func resposeSuccess() {
        showAlert(message: "Successfull!")
    }
    
    func responseFailure(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }

}
