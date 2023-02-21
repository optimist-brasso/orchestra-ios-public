//
//  BulkInstrumentPurchaseViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import UIKit

class BulkInstrumentPurchaseViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: BulkInstrumentPurchaseScreen  {
        baseScreen as! BulkInstrumentPurchaseScreen
    }
    
    var presenter: BulkInstrumentPurchaseModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    var bulkType = SessionType.part
    private var viewModels: [BulkInstrumentPurchaseViewModel] = [] {
        didSet {
            if doReload {
                screen.buttonView.isHidden = viewModels.isEmpty
                screen.tableView.reloadData()
            }
        }
    }
    
    var doReload = true
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
        setupButton()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = ""
        screen.descriptionLabel.text = bulkType == .premium || bulkType == .combo ? "複数セットをまとめて購入できます" : "複数MinusOneをまとめて購入できます"
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
    }
    
    private func setupButton() {
        [screen.buttonView.bulkBuyButton,
         screen.buttonView.addToCartButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let bools = bulkType == .premium || bulkType == .combo ? viewModels.map({ $0.isPremiumBought ||  $0.isPartBought  }) : viewModels.map({ $0.isPartBought }) 
        
        
        switch sender {
        case screen.buttonView.bulkBuyButton:
            if !bools.contains(false) {
                let  message = bulkType == .premium || bulkType == .combo ? "このセットは購入済です" : "このMinusOneは購入済です"
                showAlert(message: message)
                return
            }
            presenter?.buy()
        case screen.buttonView.addToCartButton:
            if !bools.contains(false) {
                let  message = bulkType == .premium || bulkType == .combo ? "カートに追加可能なセットはありません" : "カートに追加可能なMinusOneはありません"
                showAlert(message: message)
                return
            }
            presenter?.addToCart()
        default: break
        }
    }
    
}

// MARK: BulkInstrumentPurchaseViewInterface
extension BulkInstrumentPurchaseViewController: BulkInstrumentPurchaseViewInterface {
    
    func show(title: String?, japaneseTitle: String?) {
        screen.titleLabel.text = title
        screen.japaneseTitleLabel.text = japaneseTitle
    }
    
    func show(_ models: [BulkInstrumentPurchaseViewModel]) {
        viewModels = models
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}

// MARK: UITableViewDataSource
extension BulkInstrumentPurchaseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count //?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BulkInstrumentPurchaseTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.bulkType = bulkType
        cell.viewModel = viewModels.element(at: indexPath.row)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension BulkInstrumentPurchaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if var viewModel = viewModels.element(at: index), !viewModel.isPartBought {
            doReload = false
            viewModel.isCurrentlySelected.toggle()
            viewModels[index] = viewModel
            presenter?.select(at: index)
            doReload = true
            let cell = tableView.cellForRow(at: indexPath) as? BulkInstrumentPurchaseTableViewCell
            cell?.purchaseView.isCurrentlySelected.toggle()
        }
    }
    
}

