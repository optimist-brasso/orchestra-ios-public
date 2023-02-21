//
//  CartTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: CartViewModel? {
        didSet {
            setData()
        }
    }
    var remove: (() -> ())?
    var select: (() -> ())?
    
    //MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.curve = 6
        view.set(of: .black)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkboxButton,
                                                       contentStackView,
                                                       priceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var checkboxButton: CheckButton = {
        let button = CheckButton()
        button.changeBackground = false 
        button.tintColor = .black
        button.image.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orchestraTypeContainerStackView,
                                                       instrumentLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var orchestraTypeContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orchestraTypeStackView,
                                                      titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var orchestraTypeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orchestraTypeLabel,
                                                       premiumLabel])
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var orchestraTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "【Session】"
        label.numberOfLines = .zero
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()
    
    private lazy var premiumLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.premium.value
        label.font = .notoSansJPRegular(size: .size14)
        label.numberOfLines = .zero
        label.isHidden = true
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording\nゲンバンヒョウキ"
        label.font = .notoSansJPRegular(size: .size14)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "\(LocalizedKey.part.value)：トランペット 1st"
        label.font = .notoSansJPRegular(size: .size11)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel,
                                                       cancelButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "9999"
        label.font = .notoSansJPBold(size: .size24)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.cancelPurchase.value, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 23).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size10)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(hexString: "#C4C4C4")
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.curve = 4
        return button
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
        
        containerView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16))
        
        priceStackView.widthAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    private func setData() {
        let sessionType = SessionType(rawValue: viewModel?.sessionType?.rawValue ?? "")
        orchestraTypeLabel.text = "【\(viewModel?.type?.title ?? "")】\(sessionType?.cartTitle ?? "")"
        orchestraTypeLabel.isHidden = viewModel?.type == nil
        titleLabel.text = "\(viewModel?.title ?? "")\n\(viewModel?.titleJapanese ?? "")"
        instrumentLabel.text = "\(LocalizedKey.part.value): \(viewModel?.instrument ?? "")\(viewModel?.musician?.isEmpty ?? true ? "" : " (\(viewModel?.musician ?? ""))")"
        instrumentLabel.isHidden = viewModel?.instrument?.isEmpty ?? true
        priceLabel.text = "\((viewModel?.price ?? .zero).currencyMode) P"
        checkboxButton.isSelected = viewModel?.isSelected ?? false
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case cancelButton:
            remove?()
        case checkboxButton:
            select?()
        default: break
        }
    }
    
}
