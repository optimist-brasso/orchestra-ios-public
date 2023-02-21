//
//  PointHistoryController.swift
//  Orchestra
//
//  Created by manjil on 13/12/2022.
//

import UIKit

class PointHistoryCell: UITableViewCell {
    
    private lazy var stackView: UIStackView = {
        let label = UIStackView(arrangedSubviews: [dateLabel, priceLabel])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.spacing = 8
        label.distribution = .fill
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "購入年月日：2022. 6. 1"
        label.textAlignment = .left
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "¥160"
        label.textAlignment = .right
        label.font = .notoSansJPBold(size: .size18)
        return label
    }()
    
    private lazy var pointLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100 ポイント"
        label.font = .notoSansJPRegular(size: .size14)
        label.backgroundColor = .init(hexString: "#FAFAFA")
        return label
    }()
    var viewModel: PointHistory! {
        didSet {
            setData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareLayout() {
        selectionStyle = .none 
        contentView.addSubview(stackView)
        contentView.addSubview(pointLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            pointLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            pointLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            pointLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pointLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
    }
    
    private func setData() {
        let date = DateFormatter.toDate(dateString: viewModel.purchaseDate, format: "yyyy/MM/dd", timeZone: .utc) ?? Date()
        let dateString =  DateFormatter.toString(date: date, format: "yyyy.M.d")
        dateLabel.text = "\(LocalizedKey.purchaseDate.value):   \(dateString)"
        pointLabel.text = "\(viewModel.paidPoint.comma)ポイント"
        priceLabel.text = "¥\(viewModel.price.comma)"
    }

}

class PointHistoryController: UIViewController {
    
    //MARK: - Properties
    var presenter: PointHistoryModuleInterface?
    var viewModels: [PointHistory] = [] {
        didSet {
            if viewModels.isEmpty  {
                tableView.showEmpty()
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }
    private var hasMoreData = true
    
    //MARK: - IBOutlets
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(PointHistoryCell.self)
        tableView.registerCell(MyPageHeaderTableViewCell.self)
        tableView.sectionHeaderTopPadding = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        return rc
    }()
    
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
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func reloadPage() {
        presenter?.viewIsReady(withLoading: false, isRefreshed: true)
    }
    
}

// MARK: BillingHistoryViewInterface
extension PointHistoryController: PointHistoryViewInterface {

    func show(_ models: [PointHistory]) {
        viewModels = models
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        tableView.reloadData()
        if tableView.tableFooterView as? UIActivityIndicatorView != nil {
            tableView.tableFooterView = nil
        }
    }
    
    func show(_ hasMoreData: Bool) {
        self.hasMoreData = hasMoreData
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

//MARK: - UITableViewDataSource
extension PointHistoryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PointHistoryCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
}


//MARK: - UITableViewDataSource
extension PointHistoryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue()
        cell.title = "ポイント購入履歴"
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModels.count - 1 && hasMoreData {
            guard (tableView.tableFooterView as? UIActivityIndicatorView) == nil else {return}
            let activity = UIActivityIndicatorView(style: .medium)
            activity.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
            activity.startAnimating()
            tableView.tableFooterView = activity
            presenter?.viewIsReady(withLoading: false, isRefreshed: false)
        }
    }
    
}

