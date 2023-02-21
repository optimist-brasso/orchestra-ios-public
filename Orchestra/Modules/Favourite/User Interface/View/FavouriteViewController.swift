//
//  FavouriteViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import UIKit

import Combine

class FavouriteViewController: BaseViewController, LoggedInProtocol {
    
    var bag = Set<AnyCancellable>()
    var isStopLoading = false
    
    // MARK: Properties
    private  var screen: FavouriteScreen  {
        baseScreen as! FavouriteScreen
    }
    
    var presenter: FavouriteModuleInterface!
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    var searchType: FavouriteType = .conductor
    
    var controllers: [FavoriteContentController] = []
    private var searchText: (orchestraKeyword: String?, sessionKeyword: String?)?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        screen.searchBar.delegate = self
        screen.searchBar.searchTextField.delegate = self
        addChid()
        observeEvents()
        screen.scrollView.delegate = self
        if presenter.favouriteList.isEmpty && presenter.favouritePlayerList.isEmpty && presenter.sessionList.isEmpty {
            screen.containerStackView.isHidden = true
            showLoading()
        } else {
            hideLoading()
        }
        if let favouriteType = FavouriteType(rawValue: screen.segmentedControl.selectedSegmentIndex) {
            presenter?.getFavorite(type: favouriteType, search: screen.searchBar.getText)
            presenter.islastPlayerPage = false
            presenter.currentPlayerPage = 0
        }
        fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavouriteItem), name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupSegmentControl()
    }
    
    private func observeEvents() {
        presenter.list.dropFirst().debounce(for: .milliseconds(300), scheduler: RunLoop.main).sink(receiveValue: { [weak self] _ in
            self?.reloadCollection()
            self?.controllers.forEach({ controller in
                controller.refreshControl.endRefreshing()
            })
            self?.screen.containerStackView.isHidden = false
            self?.hideLoading()
        }).store(in: &bag)
        
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            self?.alert(msg: response.1)
        }.store(in: &bag)
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        navigationItem.leadingTitle = "Favorite"
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupSegmentControl() {
        screen.segmentedControl.addTarget(self, action: #selector(didChangeSegmentIndex(_:)), for: .valueChanged)
    }
    
    func reloadCollection() {
        if presenter.fullList.isEmpty {
            return
        }
        controllers[FavouriteType.conductor.rawValue].updateData(list:  presenter.fullList[FavouriteType.conductor.rawValue].data, tag: FavouriteType.conductor.rawValue)
        controllers[FavouriteType.hallSound.rawValue].updateData(list:  presenter.fullList[FavouriteType.hallSound.rawValue].data, tag: FavouriteType.hallSound.rawValue)
        controllers[FavouriteType.player.rawValue].updateData(list:  presenter.fullList[FavouriteType.player.rawValue].data, tag: FavouriteType.player.rawValue)
    }
    
    @objc private func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        updateIndex(index: sender.selectedSegmentIndex)
    }
    
    @objc private func cart() {
        presenter.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func didUpdateFavouriteItem(_ notification: Notification) {
        if  notification.object  == nil {
            fetchData()
        } else if let object = notification.object as? FavoriteFrom, object != .favorite  {
            fetchData()
        } else if notification.object is OrchestraFavorite {
            fetchData()
        }
    }
    
    private func fetchData() {
        if let favouriteType = FavouriteType(rawValue: screen.segmentedControl.selectedSegmentIndex) {
            presenter?.getFavorite(type: favouriteType, search: screen.searchBar.getText)
            presenter.islastPlayerPage = false
            presenter.currentPlayerPage = 0
        }
    }
}

// MARK: FavouriteViewInterface
extension FavouriteViewController: FavouriteViewInterface {
    
    func remove(model: FavouriteViewModel) {
        controllers.forEach({
            switch $0.type {
            case .conductor,
                    .hallSound,
                    .player:
                break
            case .session:
                $0.remove(model: model)
            }
        })
    }
        
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func showFavouriteList() {
        
    }
    
    func show(_ models: [FavouriteViewModel], type: OrchestraType) {
        controllers.forEach({
            switch $0.type {
            case .conductor,
                    .hallSound,
                    .player:
                break
            case .session:
                $0.set(models)
            }
        })
        
        if isStopLoading {
             self.hideLoading()
        }
        isStopLoading = true
    }
    
    func show(hasMoreData: Bool) {
        
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: {
            NotificationCenter.default.post(name: GlobalConstants.Notification.didEndRefreshContol.notificationName, object: nil)
        })
    }
    
}

extension FavouriteViewController: UISearchBarDelegate, UITextFieldDelegate {
    
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
            presenter.viewIsReady(showLoading: true, isRefreshed: true, type: .session, keyword: "")
        } else {
            presenter?.search(for: "", type: searchType, isLoading: true)
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
            presenter?.viewIsReady(showLoading: true, isRefreshed: true, type: .session, keyword: textField.text)
        } else {
            presenter?.search(for: textField.text ?? "", type: searchType, isLoading: true)
        }
        return true
    }
    
}

//MARK: UIScrollViewDelegate
extension FavouriteViewController: UIScrollViewDelegate {
    
    func addChid() {
        let conductorViewController = FavoriteContentController(tag: FavouriteType.conductor.rawValue, presenter: presenter, type: .conductor)
        conductorViewController.select = { [weak self] id, type in
            self?.select(id: id, type: type)
        }
        conductorViewController.reloadScreen = { [weak self] type in
            self?.presenter.getFavorite(type: type, search: "")
            self?.screen.searchBar.text = ""
        }
        let sessionViewController =  FavoriteContentController(tag: FavouriteType.session.rawValue, presenter: presenter, type: .session)
        sessionViewController.openDetail = { [weak self] selectedTuple in
            self?.presenter?.instrumentDetail(of: selectedTuple.instrumentId,
                                              orchestraId: selectedTuple.id,
                                              musicianId: selectedTuple.musicianId)
        }
        sessionViewController.reloadScreen = { [weak self] type in
            self?.presenter.viewIsReady(showLoading: false, isRefreshed: true, type: .session, keyword: "")
            self?.screen.searchBar.text = ""
        }
        let hallsoundViewController =  FavoriteContentController(tag: FavouriteType.hallSound.rawValue, presenter: presenter, type: .hallSound)
        hallsoundViewController.select = { [weak self] id, type in
            self?.select(id: id, type: type)
        }
        hallsoundViewController.reloadScreen = { [weak self] type in
            self?.presenter.getFavorite(type: type, search: "")
            self?.screen.searchBar.text = ""
        }
        let playerViewController = FavoriteContentController(tag: FavouriteType.player.rawValue, presenter: presenter, type: .player)
        playerViewController.select = { [weak self] id, type in
            self?.select(id: id, type: type)
        }
        playerViewController.reloadScreen = { [weak self] type in
            self?.presenter.reloadPlayerList()
            self?.screen.searchBar.text = ""
        }
        
        controllers.append(conductorViewController)
        controllers.append(sessionViewController)
        controllers.append(hallsoundViewController)
        controllers.append(playerViewController)
        
        screen.containerStackView.addArrangedSubview(conductorViewController.view)
        screen.containerStackView.addArrangedSubview(sessionViewController.view)
        screen.containerStackView.addArrangedSubview(hallsoundViewController.view)
        screen.containerStackView.addArrangedSubview(playerViewController.view)
        
        conductorViewController.view.translatesAutoresizingMaskIntoConstraints = false
        conductorViewController.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor).isActive = true
        
        sessionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        sessionViewController.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor).isActive = true
        
        hallsoundViewController.view.translatesAutoresizingMaskIntoConstraints = false
        hallsoundViewController.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor).isActive = true
        
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerViewController.view.widthAnchor.constraint(equalTo: screen.scrollView.widthAnchor).isActive = true
        
        view.layoutIfNeeded()
        view.setNeedsDisplay()
    }
    
    func select(id: Int, type: FavouriteType) {
        if let orchestraType = OrchestraType(rawValue: type.value) {
            presenter.details(of: id, type: orchestraType)
        }
    }
    
    func updateIndex(index: Int) {
        searchType = FavouriteType(rawValue: controllers.element(at: index)?.tag ?? .zero) ?? .conductor
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.screen.scrollView.contentOffset.x = CGFloat(index) *  self.screen.scrollView.frame.width
        }
        screen.searchBar.text  = ""
        researchData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let width = screen.scrollView.frame.width
        let index =  Int(offset / width)
        screen.segmentedControl.selectedSegmentIndex = index
        searchType =  FavouriteType(rawValue: index) ?? .conductor
        screen.searchBar.text =  controllers.element(at: index)?.search
        screen.setNeedsDisplay()
        researchData()
    }
    
    private func researchData() {
        if searchType != .session {
            if !(searchText?.orchestraKeyword ?? "").isEmpty {
                searchText?.orchestraKeyword = ""
                presenter?.search(for: "", type: searchType, isLoading: false)
            }
        } else {
            if !(searchText?.sessionKeyword ?? "").isEmpty {
                searchText?.sessionKeyword = ""
                presenter?.viewIsReady(showLoading: false, isRefreshed: true, type: .session, keyword: "")
            }
        }
    }
}
