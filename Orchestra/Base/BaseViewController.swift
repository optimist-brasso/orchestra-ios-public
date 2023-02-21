//
//  BaseViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit.UIViewController

class BaseViewController: UIViewController {
    
    // MARK: - properties
    let baseScreen: BaseScreen
    
    // MARK: - initialize
    init(baseScreen: BaseScreen) {
        self.baseScreen = baseScreen
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = baseScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = backButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        navigationItem.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
   @objc  func navigateBack() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("deinit \(self)")
    }
    
}

extension UIViewController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    ///   - titleAttributes: attributes to be display for title of alert
    ///   - messageAttribute: attributes for the message of alert
    func alert(title: String = "", msg: String, actions: [AlertActionable] = [AlertConstant.ok], style: UIAlertController.Style = .alert, titleAttribute: [NSAttributedString.Key: Any]? = nil, messageAttribute: [NSAttributedString.Key: Any]? = nil, completion: ((AlertActionable) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
        
        if let attributes = titleAttribute {
            //attributed title
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        if let attributes = messageAttribute {
            // Attributed message
            let attributedMsg = NSAttributedString(string: msg, attributes: attributes)
            alertController.setValue(attributedMsg, forKey: "attributedMessage")
        }
        
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                completion?(action)
            }
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}
