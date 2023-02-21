//
//  UserLoginViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

import UIKit
import AuthenticationServices
import SafariServices
import Combine
import Alamofire

class UserLoginViewController: BaseController {
    
    // MARK: Properties
    private var bag = Set<AnyCancellable>()
    var presenter: UserLoginModuleInterface?
    
    // MARK: IBOutlets
    @IBOutlet weak var password: PasswordTextField!
    @IBOutlet weak var username: Textfield!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblMailAddress: UILabel!
    
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBOutlet weak var lblSocialLoginTitle: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var loginButton: UIButton?
    
    @IBOutlet weak var lineLoginView: ImageButton?
    @IBOutlet weak var twitterLoginView: ImageButton?
    @IBOutlet weak var facebookLoginView: ImageButton?
    @IBOutlet weak var appleLoginView: ImageButton?

    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private lazy var appleManager: AppleAuthManager = {
        AppleAuthManager()
    }()
    
    // MARK: IBActions
    @IBAction func buttonTapped(_ sender: UIButton) {
        view.endEditing(true)
        switch sender {
        case btnForgotPass:
            presenter?.forgotPassword()
//        case btnLine:
//            presenter?.signupWithLine()
//        case btnTwitter:
//            presenter?.signupWithTwitter()
//        case btnFacebook:
//            presenter?.signupWithFacebook()
//        case btnInstagram:
//           // presenter?.signupWithInsta()
//            appleManager.performLogin(from: self)
        case btnRegister:
            presenter?.registerWithEmail()
        case loginButton:
//            if deploymentMode == .dev {
//                username.text = "mukeshakya11@gmail.com"
//                password.text = "123@Admin"
//            }
            presenter?.login(with: username.text, and: password.text)
        default: break
        }
    }
    
    override func observeEvents() {
        appleManager.appleResponse.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
               // self.loginWithApple(user: user)
                self.presenter?.signupWithApple(user: user)
            case .failure(let error):
                if case .canceled = error {
                    return
                }
                self.alert(msg: error.errorDescription ?? "NO_ERROR")
            }
        }.store(in: &bag)
    }
    
    // MARK: Other Functions
    private func setup() {
        buttons.forEach({
            $0.set(borderWidth: 1, of: UIColor.border)
            $0.curve = 4
        })
        textFields.forEach({
            $0.set(borderWidth: 1, of: UIColor.border)
            $0.curve = 4
            $0.leftView =  UIView(frame: CGRect(x: .zero, y: .zero, width: 3, height: .zero))
            $0.leftViewMode = .always
        })
        setupLocalization()
        setupView()
        setupGesture()
    }
    
    private func setupLocalization() {
        password.placeholder = LocalizedKey.passwordPlaceholder.value
        username.placeholder = LocalizedKey.usernamePlaceholder.value
        lblLoginTitle.text = LocalizedKey.loginTitle.value
        lblPassword.text = LocalizedKey.password.value
        lblMailAddress.text = LocalizedKey.username.value
        btnForgotPass.setAttributedTitle(LocalizedKey.forgetPassword.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size12), .foregroundColor: UIColor(hexString: "6A6969")]), for: .normal)
        
        lblSocialLoginTitle.text = LocalizedKey.socialLoginTitle.value
        btnRegister.setTitle(LocalizedKey.registerAnAccount.value, for: .normal)
        
        (view as? CancelScreen)?.cancelButton.setAttributedTitle(LocalizedKey.dontRegisterNow.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16), .foregroundColor: UIColor.white]), for: .normal)

    }
    
    private func setupView() {
        lineLoginView?.image = .line
        lineLoginView?.textColor = .line
        lineLoginView?.title = LocalizedKey.continueWithLine.value
        
        twitterLoginView?.image = .twitter
        twitterLoginView?.textColor = .twitter
        twitterLoginView?.title = LocalizedKey.continueOnTwitter.value
        
        facebookLoginView?.image = .facebook
        facebookLoginView?.textColor = .facebook
        facebookLoginView?.title = LocalizedKey.continueOnFacebook.value
        
        appleLoginView?.image = UIImage(named: "apple")
        appleLoginView?.textColor = .black
        appleLoginView?.title = LocalizedKey.continueOnApple.value
    }
    
    
    private func setupGesture() {
        [lineLoginView,
        twitterLoginView,
        facebookLoginView,
        appleLoginView].forEach({
            $0?.isUserInteractionEnabled = true
            $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
        })
    }
    
    @objc private func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            if NetworkReachabilityManager()?.isReachable == true {
                switch view {
                case lineLoginView:
                    presenter?.signupWithLine()
                case twitterLoginView:
                    presenter?.signupWithTwitter()
                case facebookLoginView:
                    presenter?.signupWithFacebook()
                case appleLoginView:
                    appleManager.performLogin(from: self)
                default: break
                }
            } else {
                showAlert(message: GlobalConstants.Error.noInternet.localizedDescription)
            }
        }
    }
     
    override func cancelAction(_ sender: AppButton) {
//        presenter?.home()
        if presentingViewController is TabBarViewController {
            dismiss(animated: true)
            return
        }
        view.window?.rootViewController = TabBarViewController()
    }
    
}

// MARK: UserLoginViewInterface
extension UserLoginViewController: UserLoginViewInterface {
    
}

extension UserLoginViewController: SFSafariViewControllerDelegate {
    
    
}

extension UserLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

