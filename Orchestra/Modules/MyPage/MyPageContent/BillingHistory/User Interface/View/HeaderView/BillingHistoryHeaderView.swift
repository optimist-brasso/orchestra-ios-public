//
//  BillingHistoryHeaderView.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//

import UIKit

class BillingHistoryHeaderView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    
    //MARK: - other Methods
    func setupData(_ date: String?, _ price: Double?) {
        if let date = date, let price = price {
            dateLabel?.text = date
            priceLabel?.text = "\(price.currencyMode) \(LocalizedKey.points.value)"
        } else {
            dateLabel?.text = ""
            priceLabel?.text = ""
        }
    }
    
}
