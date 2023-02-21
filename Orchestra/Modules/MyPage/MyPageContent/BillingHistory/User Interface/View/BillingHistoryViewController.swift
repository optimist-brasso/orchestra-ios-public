//
//  BillingHistoryViewController.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

import UIKit

class BillingHistoryViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: BillingHistoryModuleInterface?
    var viewModels: [BillingHistoryMonthlyViewModel]? {
        didSet {
            if viewModels?.isEmpty ?? true {
                tableView?.showEmpty()
            } else {
                tableView?.backgroundView = nil
            }
            tableView?.reloadData()
        }
    }
    private var hasMoreData = true
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView?
    
    //MARK: - VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true, isRefreshed: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.register(UINib(nibName: "BillingHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BillingHistoryTableViewCell")
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
}

// MARK: BillingHistoryViewInterface
extension BillingHistoryViewController: BillingHistoryViewInterface {

    func show(_ models: [BillingHistoryMonthlyViewModel]) {
        viewModels = models
    }
    
    func show(_ hasMoreData: Bool) {
        self.hasMoreData = hasMoreData
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}

//MARK: - UITableViewDataSource
extension BillingHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let viewModels = viewModels {
            return viewModels.isEmpty ? 1 : viewModels.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.element(at: section)?.items?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BillingHistoryTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.section)?.items?.element(at: indexPath.row)
        return cell
    }
    
}


//MARK: - UITableViewDataSource
extension BillingHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("BillingHistoryHeaderView", owner: self, options: nil)?.first as? BillingHistoryHeaderView
        headerView?.setupData(viewModels?.element(at: section)?.date, (viewModels?.element(at: section)?.total ?? .zero))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (viewModels?.count ?? .zero) - 1,
           indexPath.item == (viewModels?.element(at: indexPath.section)?.items?.count ?? .zero) - 1 &&
            hasMoreData {
            guard (tableView.tableFooterView as? UIActivityIndicatorView) == nil else {return}
            let activity = UIActivityIndicatorView(style: .medium)
            activity.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
            activity.startAnimating()
            tableView.tableFooterView = activity
            presenter?.viewIsReady(withLoading: false, isRefreshed: false)
        }
    }
    
}
