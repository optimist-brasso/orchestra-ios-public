//
//  BulkInstrumentPurchaseTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//

import UIKit

class BulkInstrumentPurchaseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var bulkType = SessionType.part
    
    var viewModel: BulkInstrumentPurchaseViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playerImageView,
                                                       titleStackView,
                                                       purchaseView])
        stackView.alignment = .center
        stackView.spacing = 14
        return stackView
    }()
    
    private lazy var playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexString: "#C4C4C4")
        imageView.curve = 4
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MinusOne１"
        label.font = .appFont(type: .notoSansJP(.light), size: .size18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "奏者太郎"
        label.font = .appFont(type: .notoSansJP(.light), size: .size18)
        return label
    }()
    
    private(set) lazy var purchaseView: BulkInstrumentPurchaseView = {
        let view = BulkInstrumentPurchaseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 84).isActive = true
        view.heightAnchor.constraint(equalToConstant: 39).isActive = true
        view.curve = 4
        return view
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 12.5, left: 25, bottom: 12.5, right: 25))
    }
    
    private func setData() {
        titleLabel.text = viewModel?.musician
        descriptionLabel.text = viewModel?.instrument
        if bulkType == .part {
            purchaseView.purchased = viewModel?.isPartBought ?? false
            purchaseView.isCurrentlySelected = viewModel?.isCurrentlySelected ?? false
        } else {
            let noPurchasable = (viewModel?.isPartBought ?? false) && !(viewModel?.isPremiumBought ?? false)
            if !noPurchasable {
                purchaseView.purchased = (viewModel?.isPartBought ?? false) &&  (viewModel?.isPremiumBought ?? false)
                purchaseView.isCurrentlySelected = viewModel?.isCurrentlySelected ?? false
            } else {
                purchaseView.isCurrentlySelected = false
                purchaseView.noPurchasable = noPurchasable
            }
        }
       
       
        playerImageView.showImage(with: viewModel?.image, placeholderImage: GlobalConstants.Image.playerThumbnailSmall) { [weak self] image in
            guard let image = image, let self = self else {return}
            self.playerImageView.contentMode = .top
            let width = self.playerImageView.frame.size.width
            let photo = image.resized(width * 1.60)
            self.playerImageView.image = photo
        }
    }
    
}
