//
//  SessionLayoutViewController.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import UIKit
import Combine

class SessionLayoutViewController: UIViewController {
     
    var statusBarHeight: CGFloat? {
       view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    }
    
    
    // MARK: Properties
    var presenter: SessionLayoutModuleInterface?
    private var viewModel: SessionViewModel?
    let notificationCenter = NotificationCenter.default
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: VC's Life cycle
    override func loadView() {
        super.loadView()
        fixOrientationTo(type: .landscapeRight)
        view = SessionLayoutView()
        guard let view = view as? SessionLayoutView else {
            return
        }
        view.instrumentTapped = { [weak self] model in
            view.guestLoginView.viewModel = model
            view.guestLoginView.isHidden = false
            view.guestLoginView.proceed = { [weak self] in
                self?.presenter?.instrumentDetails(of: model.instrument?.id, musicianId: model.instrument?.musicianId)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        var statusBarHeight: CGFloat = .zero
        if let value = self.statusBarHeight {
            statusBarHeight = value
        } else {
            statusBarHeight = UIApplication.statusBarHeight
        }
        presenter?.viewIsReady(with: (navigationController?.navigationBar.frame.height ?? .zero) + statusBarHeight)
        addObserver()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fixOrientationTo(type: .landscapeRight)
        tabBarController?.tabBar.isHidden = true
        guard let view = view as? SessionLayoutView else {
            return
        }
        view.guestLoginView.isHidden = true
        addObserver()
        navigationController?.setNavigationColor(color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationColor(color: UIColor(hexString: "#333333"))
        fixOrientationTo(type: .portrait)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        fixOrientationTo(type: .portrait)
//    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func setupNavBar() {
        let textColor = UIColor(hexString: "#6A6969")
        
//       let firstLabel = UILabel()
//       firstLabel.text = "一緒に演奏"
//       firstLabel.textColor = textColor
//       let firstBarButtonItem = UIBarButtonItem(customView: firstLabel)
//
//       let secondLabel = UILabel()
//       secondLabel.text = " 曲名"
//       secondLabel.textColor = textColor
//       let secondBarButtonItem = UIBarButtonItem(customView: secondLabel)
//       navigationItem.leftBarButtonItems = [firstBarButtonItem, secondBarButtonItem]
        
        let rightButton = UIButton()
        rightButton.setTitle("  データ購入済  ", for: .normal)
        rightButton.setTitleColor(textColor, for: .normal)
        rightButton.setImage(GlobalConstants.Image.purchased, for: .normal)
        
        let rightItem = UIBarButtonItem(customView: rightButton)
        let crossButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(crossButtonTapped))
        crossButton.tintColor = .black
//        crossButton.tintColor = UIColor(hexString: "#161616")
        if viewModel?.layouts?.contains(where: {$0.instrument?.isBought ?? false}) ?? false {
            navigationItem.rightBarButtonItems = [crossButton, rightItem]
        } else {
            navigationItem.rightBarButtonItem = crossButton
        }
        
        navigationItem.title = ""
    }
    
    private func fixOrientationTo(type: UIInterfaceOrientation) {
        UIDevice.current.setValue(type.rawValue, forKey: "orientation")
    }
    
    @objc private func appMovedToForeground() {
        fixOrientationTo(type: .landscapeRight)
    }
    
    @objc private func backButtonTapped() {
        presenter?.previousModule()
    }
    
    @objc private func crossButtonTapped() {
        presenter?.previousModule()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: SessionLayoutViewInterface
extension SessionLayoutViewController: SessionLayoutViewInterface {
    
    func show(_ model: SessionViewModel) {
        viewModel = model
        (view as? SessionLayoutView)?.setupData(with: model)
        setupNavBar()
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                               AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter?.login(for: mode)
            }
        }
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.presenter?.previousModule()
        })
    }
    
}

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 15.0, *) {
           return 0
        }
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return shared.statusBarFrame.height
    }
}

