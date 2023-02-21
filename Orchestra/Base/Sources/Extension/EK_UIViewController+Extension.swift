//
//  EK_UIViewController+Extension.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import UIKit.UIViewController
import UIKit.UIColor
import MBProgressHUD

public extension UIViewController {
    
    //MARK: MBProgressHUD
    private var progressHud: MBProgressHUD {
        if let progressHud = objc_getAssociatedObject(self, &Associate.hud) as? MBProgressHUD {
            progressHud.isUserInteractionEnabled = true
            return progressHud
        }
        return setProgressHud()
    }
    
    private var progressHudIsShowing: Bool {
        return progressHud.isHidden
    }
    
    private func setProgressHud() -> MBProgressHUD {
        let progressHud:  MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.tintColor = .darkGray
        progressHud.removeFromSuperViewOnHide = true
        progressHud.label.textColor = .darkGray
        objc_setAssociatedObject(self, &Associate.hud, progressHud, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return progressHud
    }
    
    func showLoading() {
        progressHud.show(animated: false)
    }
    
    func showLoading(with message: String = "") {
        progressHud.label.text = message
        progressHud.show(animated: false)
    }
    
    func hideLoading() {
        progressHud.label.text = ""
        progressHud.completionBlock = {
            objc_setAssociatedObject(self, &Associate.hud, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        progressHud.hide(animated: false)
    }
    
    //MARK: Presentaion
    func presentFullScreen(_ viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }
    
    //MARK: Alert
    func getAlert(message: String?, title: String?, style: UIAlertController.Style? = .alert) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func alert(message: String?) {
        let alertController = getAlert(message: message, title: nil)
        alertController.addAction(title: LocalizedKey.ok.value, handler: nil)
        alertController.modalPresentationStyle = .fullScreen
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(message: String?, title: String? = "",  okAction: (()->())? = nil) {
        let alertController = getAlert(message: message, title: title)
        alertController.addAction(title: LocalizedKey.ok.value, handler: okAction)
        alertController.modalPresentationStyle = .fullScreen
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithOkCancel(message: String?, title: String? = "", style: UIAlertController.Style? = .alert, okTitle: String? = LocalizedKey.ok.value, okStyle: UIAlertAction.Style = .default, cancelTitle: String? = LocalizedKey.cancel.value, cancelStyle: UIAlertAction.Style = .default, okAction: (()->())? = nil, cancelAction: (()->())? = nil) {
        let alertController = getAlert(message: message, title: title)
        alertController.addAction(title: okTitle, handler: okAction)
        alertController.addAction(title: cancelTitle, style: cancelStyle, handler: cancelAction)
        alertController.modalPresentationStyle = .fullScreen
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: UIAlertController
extension UIAlertController {
    
    func addAction(title: String?, style: UIAlertAction.Style = .default, handler: (()->())? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        })
        addAction(action)
    }
    
}

//MARK: Associate
struct Associate {
    static var hud: UInt8 = 0
}
