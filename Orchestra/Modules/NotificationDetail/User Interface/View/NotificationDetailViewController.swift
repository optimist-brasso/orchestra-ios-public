//
//  NotificationDetailViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import UIKit

class NotificationDetailViewController: UIViewController {
    
    // MARK: Properties
    var presenter: NotificationDetailModuleInterface!
    var isNotificationDetail: Bool = true
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    
    private var viewModel: NotificationDetailViewModel? {
        didSet {
            setData()
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var descriptionConstraint: NSLayoutConstraint?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewIsReady()
    }
    
    // MARK: IBActions
    @IBAction func buttonBack(_ sender: Any) {
        presenter?.listing()
    }
   
    @IBAction func buttonShare(_ sender: Any) {
        UIApplication.share(viewModel?.description ?? "")
    }
    
    // MARK: Other Functions
    private func setup() {
        scrollView?.isHidden = true
        setupNavBar()
        setupImageView()
        setupTextView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = isNotificationDetail ? "News" : "Banner"
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = backButtonItem
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        
        navigationItem.title = ""
        
        if !isNotificationDetail {
            let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
            self.notificationBarButtonItem = notificationBarButtonItem
            navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
        } else {
            navigationItem.rightBarButtonItem = cartBarButtonItem
        }
    }
    
    private func setupImageView() {
        imgNotification.curve = 8
        imgNotification.isHidden = true
    }
    
    private func setupTextView() {
        descriptionTextView?.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView?.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        descriptionTextView?.isSelectable = true
        descriptionTextView?.isEditable = false
        descriptionTextView?.isUserInteractionEnabled = true
        descriptionTextView?.dataDetectorTypes = .link
        descriptionTextView?.textContainerInset = .zero
        descriptionTextView?.textContainer.lineFragmentPadding = .zero
    }
    
    private func setData() {
        scrollView?.isHidden = false
        imgNotification.showImage(with: viewModel?.image) { [weak self] image in
            guard let image = image else { return }
            let ratio = image.ratio
            self?.heightConstraint?.constant = (self?.imgNotification.frame.width ?? .zero) * ratio.height
        }
        imgNotification.isHidden = viewModel?.image?.isEmpty ?? true
        lblTitle.text = viewModel?.title ?? "" + "-"
        descriptionTextView?.text = viewModel?.description
        descriptionTextView?.isHidden = viewModel?.description?.isEmpty ?? true
        lblDate.text = viewModel?.date
        descriptionConstraint?.constant = descriptionTextView?.contentSize.height ?? .zero
    }
    
    @objc private func cart() {
        presenter?.cart()
    }

    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func navigateBack() {
         view.endEditing(true)
         navigationController?.popViewController(animated: true)
     }
    
}

// MARK: NotificationDetailViewInterface
extension NotificationDetailViewController: NotificationDetailViewInterface {
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                         AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter.login(for: mode)
            }
        }
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(_ model: NotificationDetailViewModel) {
        viewModel = model
    }
    
    func show(notificationCount: Int) {
        UIApplication.shared.applicationIconBadgeNumber = notificationCount
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
}
