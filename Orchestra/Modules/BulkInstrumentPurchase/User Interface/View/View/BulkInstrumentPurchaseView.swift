//
//  BulkInstrumentPurchaseView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//

import UIKit

class BulkInstrumentPurchaseView: UIView {
    
    struct Constants {
        static let blueColor = UIColor(hexString: "#0D6483")
    }
    
    //MARK: Properties
    var purchased: Bool = false {
        didSet {
            checkboxButton.isHidden = purchased
            label.textAlignment = purchased ? .center : .left
            label.text = (purchased ? LocalizedKey.purchased : LocalizedKey.purchase).value
            label.textColor = purchased ? UIColor(hexString: "#9B9B9B") : .white
            backgroundColor = purchased ? UIColor(hexString: "#E4E3E3") : .white
            //                    set(of: .clear)
        }
    }
    var isCurrentlySelected: Bool = false {
        didSet {
            if !purchased {
                set(of: isCurrentlySelected ? Constants.blueColor : UIColor(hexString: "#757575"))
                backgroundColor = isCurrentlySelected ? Constants.blueColor : .white
                checkboxButton.isSelected = isCurrentlySelected
                checkboxButton.set(of: isCurrentlySelected ? .white : UIColor(hexString: "#757575"))
                label.textColor = isCurrentlySelected ? .white : UIColor(hexString: "#757575")
            } else {
                set(of: .clear)
            }
        }
    }
    
    var noPurchasable: Bool = false {
        didSet {
            set(of: noPurchasable ? .clear : UIColor(hexString: "#757575"))
            checkboxButton.isHidden = noPurchasable
            label.textAlignment = noPurchasable ? .center : .left
            label.text = noPurchasable ? "購入不可": LocalizedKey.purchase.value
            label.textColor = noPurchasable ? UIColor(hexString: "#9B9B9B") : .white
            backgroundColor = noPurchasable ? UIColor(hexString: "#E4E3E3") : .white
        
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkboxButton,
                                                       label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.checkboxSelected?.withTintColor(.white), for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "購入"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    //MARK: Initiliazers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
