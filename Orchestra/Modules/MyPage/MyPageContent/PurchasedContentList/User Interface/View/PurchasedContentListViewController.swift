//
//  PurchasedContentListViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class PurchasedContentListViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: PurchasedContentListScreen  {
        baseScreen as! PurchasedContentListScreen
    }
    
    var presenter: PurchasedContentListModuleInterface?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [PurchasedContentListViewModel]? {
        didSet {
            if viewModels?.isEmpty ?? true {
                screen.tableView.showEmpty()
            } else {
                screen.tableView.backgroundView = nil
            }
            screen.tableView.reloadData()
        }
    }
    
    private var purchasedModels: [PurchasedModel] = [] {
        didSet {
            if purchasedModels.isEmpty {
                screen.tableView.showEmpty()
            } else {
                screen.tableView.backgroundView = nil
            }
            screen.tableView.reloadData()
        }
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
        screen.tableView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        screen.searchBar.textField?.delegate = self
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
}

// MARK: PurchasedContentListViewInterface
extension PurchasedContentListViewController: PurchasedContentListViewInterface {
    
    func show(_ models: [PurchasedModel]) {
        purchasedModels = models
    }
    
    func show(_ models: [PurchasedContentListViewModel]) {
        viewModels = models
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: PurchasedContentListViewInterface
extension PurchasedContentListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  purchasedModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  purchasedModels[section].model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PurchasedContentListTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
       // cell.viewModel = viewModels?.element(at: indexPath.item)
        cell.purchase = purchasedModels[indexPath.section].model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeue(PurchaseHeader.self)
        view.titleLabel.text = purchasedModels[section].jpTitle
        if  purchasedModels[section].title.lowercased() == "hall sound".lowercased() {
            view.titleLabel.text =  "Hall Sound"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  item = purchasedModels[indexPath.section].model[indexPath.row]
        if let conductor = item as? PurchasedConductor, let id = conductor.id {
            presenter?.openConductor(id: id)
            return
        }
        if let hall = item as? PurchasedHallSound, let id = hall.id {
            presenter?.openHallSound(id: id)
            return
        }
        if let part = item as? PurchasedPart {
            presenter?.openPartDetail(instrumentId: part.instrumentId, orchestraId: part.id, musicianId: part.musicianId)
            return
        }
        if let premium = item as? PurchasedPremium {
            presenter?.openPremiumDetail(instrumentId: premium.instrumentId, orchestraId: premium.id, musicianId: premium.musicianId)
            return
        }
    }
    
}

// MARK: UITextFieldDelegate
extension PurchasedContentListViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.search(for: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.search(for: textField.text ?? "")
        return true
    }
    
}
