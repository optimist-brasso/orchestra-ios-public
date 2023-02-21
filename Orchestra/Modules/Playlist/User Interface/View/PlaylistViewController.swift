//
//  PlaylistViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import UIKit

class PlaylistViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: PlaylistScreen  {
        baseScreen as! PlaylistScreen
    }
    
    var presenter: PlaylistModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private var controllers = [PlaylistContentViewController]()
    var hasData: Bool = false
    private var searchText: (orchestraKeyword: String?, sessionKeyword: String?)?
    var isStopLoading = false 
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasData {
            presenter?.viewIsReady(withLoading: true, isRefreshed: true, type: .conductor)
        }
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTextfield()
        setupContentView()
        setupScrollView()
        setupSegmentControl()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        navigationItem.leadingTitle = "Playlist"
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupTextfield() {
        screen.searchBar.searchTextField.delegate = self
    }
    
    private func setupContentView() {
        let conductorView = PlaylistContentViewController(type: .conductor)
        conductorView.view.translatesAutoresizingMaskIntoConstraints = false
        conductorView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.orchestraDetail(of: selectedTuple.id, type: .conductor)
        }
        conductorView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id, instrumentId: nil, musicianId: nil, type: .conductor)
        }
        let sessionView = PlaylistContentViewController(type: .session, presenter: presenter)
        sessionView.view.translatesAutoresizingMaskIntoConstraints = false
        sessionView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.instrumentDetail(of: selectedTuple.instrumentId, orchestraId: selectedTuple.id, musicianId: selectedTuple.musicianId)
        }
        sessionView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id, instrumentId: favouriteTuple.instrumentId, musicianId: favouriteTuple.musicianId, type: .session)
        }
        let hallSoundView = PlaylistContentViewController(type: .hallSound)
        hallSoundView.view.translatesAutoresizingMaskIntoConstraints = false
        hallSoundView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.orchestraDetail(of: selectedTuple.id, type: .hallSound)
        }
        hallSoundView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id, instrumentId: nil, musicianId: nil, type: .hallSound)
        }
        [conductorView,
         sessionView,
         hallSoundView].forEach({ viewController in
            viewController.refresh = { [weak self] in
                self?.screen.searchBar.text = ""
                if viewController.type == .session {
                    self?.searchText?.sessionKeyword = ""
                } else {
                    self?.searchText?.orchestraKeyword = ""
                }
                self?.presenter?.viewIsReady(withLoading: false, isRefreshed: true, type: (viewController as PlaylistContentViewController).type)
            }
            controllers.append(viewController)
            screen.containerStackView.addArrangedSubview(viewController.view)
        })
        
        NSLayoutConstraint.activate([
            conductorView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor),
            sessionView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor),
            hallSoundView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor)
        ])
    }
    
    private func setupScrollView() {
        screen.scrollView.delegate = self
    }
    
    private func setupSegmentControl() {
        screen.segmentedControl.addTarget(self, action: #selector(didChangeSegmentIndex(_:)), for: .valueChanged)
    }
    
    @objc private func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        let isSession = sender.selectedSegmentIndex == 1
        loadDataOnScroll(isSession: isSession)
        updateIndex(index: sender.selectedSegmentIndex)
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
}

// MARK: PlaylistViewInterface
extension PlaylistViewController: PlaylistViewInterface {
    
    func show(_ models: [PlaylistViewModel], isSession: Bool, reload: Bool) {
        
        if isSession {
            controllers.first(where: {$0.type == .session})?.set(models, reload: reload)
            if isStopLoading {
                 self.hideLoading()
            }
            isStopLoading = true
        } else {
            controllers.forEach({
                if $0.type != .session {
                    $0.set(models, reload: reload)
                }
            })
            self.hideLoading()
        }
        hasData = !models.isEmpty
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                               AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter?.login(for: mode)
            }
        }
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func endRefreshing() {
        controllers.forEach({
            $0.refreshControl.endRefreshing()
//            $0.tableView.reloadData()
            if $0.tableView.tableFooterView as? UIActivityIndicatorView != nil {
                $0.tableView.tableFooterView = nil
            }
        })
    }
    
    func show(hasMoreData: Bool) {
        controllers.first(where: {$0.type == .session})?.hasMoreData = hasMoreData
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITextFieldDelegate
extension PlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        let isSession = screen.segmentedControl.selectedSegmentIndex == 1
        if searchText != nil {
            if isSession {
                searchText?.sessionKeyword = ""
            } else {
                searchText?.orchestraKeyword = ""
            }
        } else {
            searchText = (orchestraKeyword: "", sessionKeyword: "")
        }
        presenter?.search(for: "", type: screen.segmentedControl.selectedSegmentIndex == 1 ? .session : .conductor)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        let isSession = screen.segmentedControl.selectedSegmentIndex == 1
        if searchText != nil {
            if isSession {
                searchText?.sessionKeyword = textField.text
            } else {
                searchText?.orchestraKeyword = textField.text
            }
        } else {
            searchText = (orchestraKeyword: !isSession ? textField.text : "", sessionKeyword: isSession ? textField.text : "")
        }
        presenter?.search(for: textField.text ?? "", type: screen.segmentedControl.selectedSegmentIndex == 1 ? .session : .conductor)
        return true
    }
    
}

//MARK: UIScrollViewDelegate
extension PlaylistViewController: UIScrollViewDelegate {
    
    func updateIndex(index: Int) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.screen.scrollView.contentOffset.x = CGFloat(index) *  (self?.screen.scrollView.frame.width ?? .zero)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let width = screen.scrollView.frame.width
        let index =  Int(offset / width)
        screen.segmentedControl.selectedSegmentIndex = index
        screen.setNeedsDisplay()
        let isSession = screen.segmentedControl.selectedSegmentIndex == 1
        loadDataOnScroll(isSession: isSession)
        
    }
    
    private func loadDataOnScroll(isSession:  Bool) {
        if isSession {
            //screen.searchBar.text = searchText?.sessionKeyword
            if !(searchText?.sessionKeyword?.isEmpty ?? true) {
                searchText?.sessionKeyword = ""
                presenter?.viewIsReady(withLoading: false, isRefreshed: true, type: .session)
            }
        } else {
            if !(searchText?.orchestraKeyword?.isEmpty ?? true) {
                searchText?.orchestraKeyword  = ""
                presenter?.viewIsReady(withLoading: false, isRefreshed: true, type: .conductor)
            }
        }
        screen.searchBar.text = ""
    }
    
}

