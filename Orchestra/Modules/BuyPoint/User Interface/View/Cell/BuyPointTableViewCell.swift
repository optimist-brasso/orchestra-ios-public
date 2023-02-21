//
//  BuyPointTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//

import UIKit

class PointHeaderLabel: UIStackView {
    private(set) lazy var title: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPRegular(size: .size18)
        label.text = "うち有償ポイント"
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var value: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPMedium(size: .size22)
        label.text = "10000"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private(set) lazy var point: PaddingLabel = {
        let label = PaddingLabel(.init(top: 0, left: 0, bottom: 0, right: 2))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPMedium(size: .size18)
        label.text =  "P"//"ポイント"
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareLayout() {
        axis = .horizontal
        spacing = 4
        distribution = .fill
        addArrangedSubview(title)
        addArrangedSubview(value)
        addArrangedSubview(point)
        
        NSLayoutConstraint.activate([
            point.widthAnchor.constraint(equalToConstant: 16),
            title.widthAnchor.constraint(equalToConstant: 183)
        ])
    }
    
}

class BuyPointTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: BuyPointViewModel? {
        didSet {
            setData()
        }
    }
    var buy: (() -> Void)?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView,
                                                       detailStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var imageViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.curve = 2
        view.backgroundColor = UIColor(hexString: "#C4C4C4", alpha: 0.5)
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 83 / 151).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       priceLabel,
                                                       descriptionLabel,
                                                       buyLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "original recording"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size13)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "original recording description"
        label.numberOfLines = 2
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        return label
    }()
    
    private lazy var buyLabel: UILabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(hexString: "#B2964E")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        label.text = LocalizedKey.buy.value
        label.textColor = .white
        label.curve = 2
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        return label
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
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 21, bottom: 8, right: 16))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.43).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
    }
    
    private func setData() {
        thumbnailImageView.showImage(with: viewModel?.image)
        titleLabel.text = viewModel?.title
        priceLabel.text = viewModel?.price
        descriptionLabel.text = viewModel?.description
        descriptionLabel.isHidden = viewModel?.description?.isEmpty ?? true
    }
    
    @objc private func buttonTapped() {
        buy?()
    }
    
}


class PointHeader: UITableViewHeaderFooterView {
    
    private(set) lazy var totalPointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.title.text = "ポイント合計"
        view.backgroundColor = .init(hexString: "#B2964E")
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.title.textColor = .white
        view.value.textColor = .white
        view.point.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    private(set) lazy var paidPointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.title.text = "うち有償ポイント"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var limitedTimePointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.title.text = "うち期間限定ポイント"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var expirePointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = "2022年08月31日まで"
        return view
    }()
    
    private(set) lazy var expire2PointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.title.text = "2022年09月01日まで"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.point.isHidden = true
        view.value.isHidden = true
        return view
    }()
    
    private(set) lazy var button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .init(hexString: "#0D6483")
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.setAttributedTitle("確認する".attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var goToFreePoint: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(totalPointView)
        stackView.setCustomSpacing(8, after: totalPointView)
        stackView.addArrangedSubview(paidPointView)
        stackView.addArrangedSubview(limitedTimePointView)
        stackView.addArrangedSubview(expirePointView)
        stackView.addArrangedSubview(expire2PointView)
        expire2PointView.addArrangedSubview(button)
                
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            totalPointView.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.trailingAnchor.constraint(equalTo: expire2PointView.trailingAnchor, constant: 2)
        ])
    }
    
    @objc private func action(_ sender: UIButton) {
        goToFreePoint?()
    }
}

class PointCell: UITableViewCell {
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var value: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPMedium(size: .size22)
        label.text = "10,000\n+2,000サービス"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var image: UIImageView = {
        let label = UIImageView()
        label.image = .point
        label.contentMode = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var button: TextControl = {
        let view = TextControl()
        view.isUserInteractionEnabled = true
        view.isEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
      //  view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    private(set) lazy var overlyButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
       view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    
    var point: BundleList! {
        didSet {
           if point != nil {
                configurationCell()
            }
        }
    }
    var buy: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
       //button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        contentView.backgroundColor =   .init(hexString: "#F5F5F5")
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(value)
        contentView.addSubview(button)
        contentView.addSubview(overlyButton)
                
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 55),
            
            button.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 4),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.heightAnchor.constraint(equalToConstant: 55),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            overlyButton.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            overlyButton.topAnchor.constraint(equalTo: button.topAnchor),
            overlyButton.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            overlyButton.bottomAnchor.constraint(equalTo: button.bottomAnchor),
        ])
    }
    
    private func configurationCell() {
        let string = "\(point.paidPoint.comma)" + "\n+\(point.freePoint.comma)サービス"
        value.text = string
        button.value.text = "¥\(point.price.comma)"
    }
    
    @objc private func action(_ sender: TextControl) {
        buy?(point.identifier)
        print(point.identifier)
    }
}

class TextControl: UIControl {
    private(set) lazy var buy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPRegular(size: .size14)
        label.text = "購入する"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var value: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPMedium(size: .size22)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "¥100"
        return label
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        isEnabled = true
        prepareLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        backgroundColor = .init(hexString: "#0D6483")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(stackView)
        stackView.addArrangedSubview(buy)
        stackView.addArrangedSubview(value)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
