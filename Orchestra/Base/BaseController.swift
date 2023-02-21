//
//  BaseController.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit
import Combine

 class BaseController: UIViewController, StoryboardInitializable {
    
    /// The baseView of controller
     private(set) var baseScreen: BaseScreen!
    
    /// The baseViewModel of controller
     private(set) var basePresenter: BasePresenter!
    
    /// The trigger when the presentedController was dismissed with swipe down
    public let didDismissPresentedController = PassthroughSubject<Bool, Never>()
    
    /// The flag to check if the controller was initialized from storyboard
    private let isStoryboardIntialized: Bool
    
    /// when view is loaded
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        /// setup UI
        setupUI()
        
        /// observe events
        observeEvents()
        
        /// observe screen
        observerScreen()
        
        bindUI()
        
        navigationItem.title = ""
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        //imageView.backgroundColor = .white
        navigationItem.titleView =  imageView
        navigationItem.title = ""
        addCancelAction()
    }
    
    /// Method that will set the viewmodel after initialization from storyboard
    /// - Parameter viewModel: the viewmodel for the controller
    func setViewModel(presenter: BasePresenter) {
        guard basePresenter == nil else { return }
        basePresenter = presenter
    }
    
    /// Initializer for a controller
    /// - Parameters:
    ///   - baseView: the view associated with the controller
    ///   - baseViewModel: viewModel associated with the controller
      init(screen: BaseScreen, presenter: BasePresenter) {
        self.baseScreen = screen
        self.basePresenter = presenter
        self.isStoryboardIntialized = false
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Not available
    required public init?(coder: NSCoder) {
        self.isStoryboardIntialized = true
        super.init(coder: coder)
    }
    
    /// Load the base view as the view of controller
    override open func loadView() {
        super.loadView()
        guard !isStoryboardIntialized else { return }
        view = baseScreen
    }
    
    /// setup trigger/Users/rohitlama/Desktop/orchestra-ios/Pods/XLPagerTabStrip/Sources/SegmentedPagerTabStripViewController.swift:    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    open func setupUI() {}
    
    /// Observer for events
    open func observeEvents() {}
     
    /// Observer for events of screen
    open func observerScreen() {}
     
     
    open func bindUI() {  }
    
    /// Deint call check
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
}

extension BaseController {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.didDismissPresentedController.send(true)
    }
}

extension BaseController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    ///   - titleAttributes: attributes to be display for title of alert
    ///   - messageAttribute: attributes for the message of alert
//    func alert(title: String = "", msg: String, actions: [AlertActionable] = [AlertConstant.ok], style: UIAlertController.Style = .alert, titleAttribute: [NSAttributedString.Key: Any]? = nil, messageAttribute: [NSAttributedString.Key: Any]? = nil, completion: ((AlertActionable) -> Void)? = nil) {
//        let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
//
//        if let attributes = titleAttribute {
//            //attributed title
//            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
//            alertController.setValue(attributedTitle, forKey: "attributedTitle")
//        }
//
//        if let attributes = messageAttribute {
//            // Attributed message
//            let attributedMsg = NSAttributedString(string: msg, attributes: attributes)
//            alertController.setValue(attributedMsg, forKey: "attributedMessage")
//        }
//
//        actions.forEach { action in
//            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
//                completion?(action)
//            }
//            alertController.addAction(alertAction)
//        }
//        present(alertController, animated: true, completion: nil)
//    }
    
    
    func addCancelAction() {
        if let cancelScreen = view as? CancelScreen {
            navigationItem.hidesBackButton = true
            cancelScreen.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        } else {
            navigationItem.hidesBackButton = false
        }
    }
    
    @objc func cancelAction(_ sender: AppButton) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    

}
