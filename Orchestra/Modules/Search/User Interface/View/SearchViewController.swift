//
//  SearchViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import UIKit

class SearchViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: SearchScreen  {
        baseScreen as! SearchScreen
    }
    
    var presenter: SearchModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private var controllers = [SearchContentViewController]()
    var hasData: Bool = false
    private var searchText: (orchestraKeyword: String?, sessionKeyword: String?)?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasData {
            presenter?.viewIsReady(withLoading: true, isRefreshed: false, type: .conductor, keyword: nil)
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
        navigationItem.leadingTitle = "Search"
        
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
        let conductorView = SearchContentViewController(type: .conductor)
        conductorView.view.translatesAutoresizingMaskIntoConstraints = false
        conductorView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.orchestraDetail(of: selectedTuple.id,
                                             type: .conductor)
        }
        conductorView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id,
                                       instrumentId: nil,
                                       musicianId: nil,
                                       type: .conductor)
        }
        let sessionView = SearchContentViewController(type: .session, presenter: presenter)
        sessionView.view.translatesAutoresizingMaskIntoConstraints = false
        sessionView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.instrumentDetail(of: selectedTuple.instrumentId,
                                              orchestraId: selectedTuple.id,
                                              musicianId: selectedTuple.musicianId)
        }
        sessionView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id,
                                       instrumentId: favouriteTuple.instrumentId,
                                       musicianId: favouriteTuple.musicianId,
                                       type: .session)
        }
        let hallSoundView = SearchContentViewController(type: .hallSound)
        hallSoundView.view.translatesAutoresizingMaskIntoConstraints = false
        hallSoundView.openDetail = { [weak self] selectedTuple in
            self?.presenter?.orchestraDetail(of: selectedTuple.id,
                                             type: .hallSound)
        }
        hallSoundView.favourite = { [weak self] favouriteTuple in
            self?.presenter?.favourite(of: favouriteTuple.id,
                                       instrumentId: nil,
                                       musicianId: nil,
                                       type: .hallSound)
        }
        [conductorView,
         sessionView,
         hallSoundView].forEach({ [weak self] viewController in
            viewController.refresh = { [weak self] in
                self?.screen.searchBar.text = ""
                if viewController.type == .session {
                    self?.searchText?.sessionKeyword = ""
                } else {
                    self?.searchText?.orchestraKeyword = ""
                }
                self?.presenter?.viewIsReady(withLoading: false, isRefreshed: true, type: (viewController as SearchContentViewController).type, keyword: "")
            }
            controllers.append(viewController)
            screen.containerStackView.addArrangedSubview(viewController.view)
        })
        
        NSLayoutConstraint.activate([
            conductorView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor),
            sessionView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor),
            hallSoundView.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor)
        ])
//        view.layoutIfNeeded()
//        view.setNeedsDisplay()
    }
    
    private func setupScrollView() {
        screen.scrollView.delegate = self
    }
    
    private func setupSegmentControl() {
        screen.segmentedControl.addTarget(self, action: #selector(didChangeSegmentIndex(_:)), for: .valueChanged)
    }
    
    @objc private func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        let isSession = sender.selectedSegmentIndex == 1
        if isSession {
            screen.searchBar.text = searchText?.sessionKeyword
        } else {
            screen.searchBar.text = searchText?.orchestraKeyword
        }
        updateIndex(index: sender.selectedSegmentIndex)
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
}

// MARK: SearchViewInterface
extension SearchViewController: SearchViewInterface {
    
    func show(_ session: SearchViewModel) {
        controllers.first(where: {$0.type == .session})?.toggle(session: session)
    }
    
    func show(_ models: [SearchViewModel], isSession: Bool, isReload: Bool) {
        hideLoading()
        if isSession {
            controllers.first(where: {$0.type == .session})?.set(models, reload: isReload)
        } else {
            controllers.forEach({
                if $0.type != .session {
                    $0.set(models, reload: isReload)
                }
            })
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
            $0.tableView.reloadData()
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

//// MARK: UITableViewDataSource
//extension SearchViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModels?.count ?? .zero
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SearchTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
//        cell.viewModel = viewModels?.element(at: indexPath.row)
//        return cell
//    }
//    
//}
//
//// MARK: UITableViewDelegate
//extension SearchViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var type: OrchestraType = .conductor
//        switch screen.segmentedControl.selectedSegmentIndex {
//        case 0:
//            type = .conductor
//        case 1:
//            type = .session
//        default:
//            type = .hallSound
//        }
//        presenter?.orchestraDetail(of: viewModels?.element(at: indexPath.row)?.id, type: type)
//    }
//    
//}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
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
        if isSession {
            presenter?.viewIsReady(withLoading: true, isRefreshed: true, type: .session, keyword: "")
        } else {
            presenter?.search(for: "")
        }
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
        if isSession {
            presenter?.viewIsReady(withLoading: true, isRefreshed: true, type: .session, keyword: textField.text)
        } else {
            presenter?.search(for: textField.text ?? "")
        }
        return true
    }
    
}

//MARK: UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    
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
        if isSession {
            screen.searchBar.text = searchText?.sessionKeyword
        } else {
            screen.searchBar.text = searchText?.orchestraKeyword
        }
    }
    
}
