//
//  BillingHistoryTableViewCell.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//

import UIKit

class BillingHistoryTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var viewModel: BillingHistoryViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var dateOfPurchaseLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var instrumentLabel: UILabel?
    @IBOutlet weak var premiumLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func setData() {
        premiumLabel?.isHidden = !(viewModel?.isPremium ?? false)
        if let sessionType = viewModel?.sessionType {
            premiumLabel?.text = sessionType.cartTitle
            premiumLabel?.isHidden = false
        } else {
            premiumLabel?.text = "Premium映像"
        }
//        orchestraTypeLabel.text = "【\(viewModel?.type?.title ?? "")】\(sessionType?.cartTitle ?? "")"
        dateOfPurchaseLabel?.text = "\(LocalizedKey.purchaseDate.value): " + (viewModel?.date ?? "")
        priceLabel?.text = "\((viewModel?.price ?? .zero).currencyMode) \(LocalizedKey.points.value)"
        typeLabel?.text = "[\(viewModel?.type?.title ?? "")]"
        typeLabel?.isHidden = viewModel?.type == nil
        titleLabel?.text = viewModel?.title
        instrumentLabel?.text = "\(LocalizedKey.part.value): \(viewModel?.instrument ?? "")\(viewModel?.musician?.isEmpty ?? true ? "" : " (\(viewModel?.musician ?? ""))")"
        instrumentLabel?.isHidden = viewModel?.instrument?.isEmpty ?? true
    }
    
}
