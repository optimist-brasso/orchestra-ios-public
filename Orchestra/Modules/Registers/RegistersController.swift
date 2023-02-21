//
//  RegistersController.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit
import Combine
import LineSDK
import FBSDKLoginKit

import SafariServices
import AuthenticationServices
import FirebaseAuth
import Alamofire

class RegistersController: BaseController {
    
    private var screen: RegisterScreen  {
        baseScreen as! RegisterScreen
    }
    var provider: OAuthProvider?
    private var presenter: RegistersPresenter  {
        basePresenter as! RegistersPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen.termButton.delegate = self
        setupGesture()
    }
    
    private lazy var appleManager: AppleAuthManager = {
        AppleAuthManager()
    }()
    
    override func observerScreen() {
        screen.registerByEmailButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            if self.showAlert() {
                return
            }
            self.presenter.trigger.send(.registerByEmail)
        }.store(in: &presenter.bag)
        
        screen.loginButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            if self?.navigationController?.viewControllers.count ?? .zero > 1 {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            // NotificationCenter.default.post(name: Notification.homePage, object: nil)
            self?.presenter.trigger.send(.login)
        }.store(in: &presenter.bag)
        
//        screen.registerByLineButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
//            self?.signupWithLine()
//        }.store(in: &presenter.bag)
//
//        screen.registerByFacebookButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
//            self?.signupWithFacebook()
//        }.store(in: &presenter.bag)
//
//
//        screen.registerByTwitterButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
//            self?.signupWithTwitter()
//        }.store(in: &presenter.bag)
//
//
//        screen.registerByAppleButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
//            guard let self = self else { return }
//            if self.showAlert() {
//                return
//            }
//            self.appleManager.performLogin(from: self)
//        }.store(in: &presenter.bag)
        
        screen.tickButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.screen.tickButton.isSelected.toggle()
           // self.makeButtonsUserInteractionEnabled()
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink {  [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
            if !response.1 {
                self.alert(msg: response.0)
            } else {
                self.presenter.trigger.send(.splash)
            }
        }.store(in: &presenter.bag)
        
        
        appleManager.appleResponse.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                
                self.loginWithApple(user: user)
            case .failure(let error):
                if case .canceled = error {
                    return
                }
                self.alert(msg: error.errorDescription ?? "NO_ERROR")
            }
        }.store(in: &presenter.bag)
    }
    
    func makeButtonsUserInteractionEnabled() {
        [screen.registerByEmailButton,
         screen.registerByLineButton,
         screen.registerByTwitterButton,
         screen.registerByFacebookButton,
         screen.registerByAppleButton].forEach {
            $0.isUserInteractionEnabled = screen.tickButton.isSelected
        }
    }
    
    private func setupGesture() {
        [screen.registerByLineButton,
         screen.registerByTwitterButton,
         screen.registerByFacebookButton,
         screen.registerByAppleButton].forEach({
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
        })
    }
    
    override func cancelAction(_ sender: AppButton) {
//        presenter?.home()
        if presentingViewController is TabBarViewController {
            dismiss(animated: true)
            return
        }
        view.window?.rootViewController = TabBarViewController()
    }
    
    @objc private func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            if NetworkReachabilityManager()?.isReachable == true {
                switch view {
                case screen.registerByLineButton:
                    signupWithLine()
                case screen.registerByTwitterButton:
                    signupWithTwitter()
                case screen.registerByFacebookButton:
                    signupWithFacebook()
                case screen.registerByAppleButton:
                    if showAlert() {
                        return
                    }
                    appleManager.performLogin(from: self)
                default: break
                }
            } else {
                showAlert(message: GlobalConstants.Error.noInternet.localizedDescription)
            }
        }
    }
    
}

extension RegistersController {
    
    func signupWithTwitter() {
        if showAlert() {
            return
        }
        do {
           try  Auth.auth().signOut()
            
        } catch {
            print(error.localizedDescription)
        }
        
        provider = OAuthProvider(providerID: "twitter.com")
        self.showLoading()
        provider?.getCredentialWith(nil) { [weak self] credential, error in
             guard let self = self else { return }
             if let error = error {
                 print(error.localizedDescription)
                 self.alert(msg:  LocalizedKey.loginFail.value)
                 self.hideLoading()
                 return
             }
             if let credential = credential {
                 Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                     guard let self = self else { return }
                     if let error = error {
                         print(error.localizedDescription)
                         self.hideLoading()
                         self.alert(msg:  LocalizedKey.loginFail.value)
                         return
                     }
                     if let authResult = authResult {
                         let credential = (authResult.credential as? OAuthCredential)
                         
                         self.presenter.request(token: credential?.accessToken ?? "", userIdentifier: credential?.secret ?? "", type: .twitter)
                         print(authResult)
                     }
                 }
             }
         }
    }
    
    func signupWithLine() {
        if showAlert() {
            return
        }
        self.showLoading()
        LoginManager.shared.login(permissions: [.profile], in: self) { [weak self]
            result in
            guard let self = self else { return }
            switch result {
            case .success(let loginResult):
                if  loginResult.userProfile !=  nil {
                    self.presenter.request(token: loginResult.accessToken.value, type: .line)
                }
            case .failure(let error):
                self.hideLoading()
                if error.errorCode != 3003 {
                    self.alert(msg:  LocalizedKey.loginFail.value)
                }
            }
        }
       
    }
    
    func showAlert() -> Bool {
        if !screen.tickButton.isSelected {
            showAlert(message: "続けるにはチェックボッスをチェックしてください")
            return true
        }
        return false
    }
    
    
    func signupWithFacebook() {
        if showAlert() {
            return
        }
        let loginManager = LoginManager()
        loginManager.logOut()
        showLoading()
        loginManager.logIn(permissions: [.email, .publicProfile], viewController: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_, _, let token):
                if let accessToken = token?.tokenString {
                    self.presenter.request(token: accessToken, type: .facebook)
                }
            case .cancelled:
                self.hideLoading()
            case .failed(_):
                self.hideLoading()
               // self.alert(msg: error.localizedDescription)
                self.alert(msg:  LocalizedKey.loginFail.value)
               
            }
        }
    }
    
    func loginWithApple(user: AppleUser) {
        showLoading()
        print(user)
        presenter.request(token: user.idToken, userIdentifier: user.userId,type: .apple)
        
    }
}

extension RegistersController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if  URL.absoluteString == "terms" {
            open()
        }
        return false
    }
    
    func open() {
//        if let url = URL(string: "https://brasso.jp/terms") {
//            UIApplication.shared.open(url)
//        }
        let viewController = WebViewViewController(title: "", url: "https://brasso.jp/terms")
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
}

extension RegistersController: SFSafariViewControllerDelegate {}
extension RegistersController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
