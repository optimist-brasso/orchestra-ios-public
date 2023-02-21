//
//  RecordingListViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class RecordingListViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: RecordingListScreen  {
        baseScreen as! RecordingListScreen
    }
    
    var presenter: RecordingListModuleInterface?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [RecordingListViewModel]? {
        didSet {
            if viewModels?.isEmpty ?? true {
                screen.tableView.showEmpty()
            } else {
                screen.tableView.backgroundView = nil
            }
            screen.tableView.reloadData()
        }
    }
    private var hasMoreData = true
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true, isRefreshed: false, keyword: nil)
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
//        screen.tableView.emptyDataSetDataSource = self
    }
    
    private func setupSearchBar() {
        screen.searchBar.textField?.delegate = self
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false, isRefreshed: true, keyword: nil)
    }
    
}

// MARK: RecordingListViewInterface
extension RecordingListViewController: RecordingListViewInterface {
    
    func show(_ models: [RecordingListViewModel]) {
        viewModels = models
    }
    
    func show(_ hasMoreData: Bool) {
        self.hasMoreData = hasMoreData
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
        if screen.tableView.tableFooterView as? UIActivityIndicatorView != nil {
            screen.tableView.tableFooterView = nil
        }
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: PurchasedContentListViewInterface
extension RecordingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecordingListTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.row)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension RecordingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item  == (viewModels?.count ?? .zero) - 1 &&
            hasMoreData {
            guard (tableView.tableFooterView as? UIActivityIndicatorView) == nil else {return}
            let activity = UIActivityIndicatorView(style: .medium)
            activity.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
            activity.startAnimating()
            tableView.tableFooterView = activity
            presenter?.viewIsReady(withLoading: false, isRefreshed: false, keyword: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openRecordPlayer(of: indexPath.row)
    }
    
}

// MARK: UITextFieldDelegate
extension RecordingListViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.viewIsReady(withLoading: true, isRefreshed: true, keyword: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.viewIsReady(withLoading: true, isRefreshed: true, keyword: textField.text)
        return true
    }
    
}

////MARK: TBEmptyDataSetDataSource
//extension RecordingListViewController: TBEmptyDataSetDataSource {
//
//    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
//        return NSAttributedString(string: LocalizedKey.noData.value, attributes: [.foregroundColor : UIColor.black,
//                                                                               NSAttributedString.Key.font: UIFont.notoSansJPRegular(size: .size15)])
//    }
//
//}
