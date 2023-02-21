//
//  UIViewController+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/12/2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    func showToast(_ message: String) {
//        let lineBackgroundColor = UIColor(red: 0.13, green: 0.59, blue: 0.33, alpha: 1.0)
      
        let toastContainer = UIView()
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.backgroundColor = UIColor(hexString: "#333333")
        toastContainer.layer.cornerRadius = 20
//        toastContainer.set(borderWidth: 0.4, of: UIColor.lightGray.withAlphaComponent(0.9))
        
//        let leftLine = UIView()
//        leftLine.translatesAutoresizingMaskIntoConstraints = false
//        leftLine.backgroundColor = lineBackgroundColor
        
        let messageBox = PaddingLabel(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        messageBox.translatesAutoresizingMaskIntoConstraints = false
        messageBox.textColor = .white
        messageBox.textAlignment = .center
        messageBox.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        messageBox.text = message
        messageBox.clipsToBounds = true
        messageBox.numberOfLines = .zero
        messageBox.adjustsFontSizeToFitWidth = true
        
//        let stackView = UIStackView(arrangedSubviews: [toastContainer, messageBox])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = .zero
//        stackView.alignment = .fill
        
        let bottomSafeArea = view.safeAreaInsets.bottom
        
        view.addSubview(toastContainer)
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            toastContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(80)-(bottomSafeArea)),
            toastContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
//        leftLine.widthAnchor.constraint(equalToConstant: .zero).isActive = true
        
        toastContainer.addSubview(messageBox)
        NSLayoutConstraint.activate([
            messageBox.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
            messageBox.centerXAnchor.constraint(equalTo: toastContainer.centerXAnchor),
            messageBox.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 5),
            messageBox.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.5, delay: .zero, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = .zero
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }

    public var isTopViewController: Bool {
        if tabBarController != nil {
            return (tabBarController?.selectedViewController as? UINavigationController)?.visibleViewController == self && presentedViewController == nil
        } else if navigationController != nil {
            return navigationController?.visibleViewController === self
        } else {
            return presentedViewController == nil && isVisible
        }
    }
    
    //MARK: Alert
    func getAlert(message: String?, title: String?, style: UIAlertController.Style? = .alert) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func showAlert(message: String?, title: String? = nil,  okAction: (() -> Void)? = nil) {
        let alertController = getAlert(message: message, title: title)
        alertController.addAction(title: "OK", handler: okAction)
        alertController.modalPresentationStyle = .fullScreen
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UIAlertController {
    
    func addAction(title: String?, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        })
        addAction(action)
    }
    
}
