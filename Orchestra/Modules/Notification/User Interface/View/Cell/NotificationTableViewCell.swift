//
//  NotificationTableViewCell.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: NotificationViewModel! {
        didSet {
            setData()
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var typeView: UIView!
    
    //MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    //MARK: Setup UI
    private func setup() {
        bgView.leftCurve = 12
        imgNotification.curve = 11
        imgNotification.contentMode = .scaleAspectFill
        dottedView.rounded()
    }
    
    private func setData() {
        imgNotification.showImage(with: viewModel.image)
        lblTitle.text = "\(viewModel.title ?? "") -\n\(viewModel.description ?? "")"
        lblDate.text = viewModel.date
        typeView.backgroundColor =  .init(hexString: viewModel.color ?? "")
//        dottedView.backgroundColor = .init(hexString: viewModel.color ?? "")
        dottedView.backgroundColor = viewModel.isSeen ? .white : UIColor(hexString : "#FF0000")
    }
    
}
