//
//  PageOptionTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit

class PageOptionTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var selectedPage: OrchestraType? {
        didSet {
            var imageView: UIView?
            var titleLabel: UIView?
            switch selectedPage {
            case .conductor:
                titleLabel = conductorStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = conductorStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
                self.titleLabel.isHidden = false
                self.titleLabel.text = "最高の特等席で、プロの気迫を感じる！"
            case .session:
                titleLabel = sessionStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = sessionStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
                self.titleLabel.isHidden = false
                self.titleLabel.text = "プロの奏者と夢のセッションを楽しむ！"
            case .hallSound:
                titleLabel = hallSoundStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = hallSoundStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
                self.titleLabel.isHidden = false
                self.titleLabel.text = "客席のいろいろな場所から楽しむ！"
            case .player:
                titleLabel = playerStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = playerStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
                self.titleLabel.isHidden = true
                self.titleLabel.text = ""
            default: break
            }
            let selectedColor = UIColor(hexString: "#0D6483")
            (titleLabel as? UILabel)?.textColor = selectedColor
            imageView?.set(borderWidth: 4, of: selectedColor)
        }
    }
    var didSelect: ((OrchestraType) -> ())?
    
    //MARK: UI Properties
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [conductorStackView,
                                                       sessionStackView,
                                                       hallSoundStackView,
                                                       playerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        label.textColor = .blueButtonBackground
        label.textAlignment = .center
        label.isHidden = true 
        return label
    }()
    
    private(set) lazy var conductorStackView: PageOptionCircularView = {
        let view = PageOptionCircularView(option: .conductor)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOption(_:))))
        return view
    }()
    
    private(set) lazy var sessionStackView: PageOptionCircularView = {
        let view = PageOptionCircularView(option: .session)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOption(_:))))
        return view
    }()
    
    private(set) lazy var hallSoundStackView: PageOptionCircularView = {
        let view = PageOptionCircularView(option: .hallSound)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOption(_:))))
        return view
    }()
    
    private(set) lazy var playerStackView: PageOptionCircularView = {
        let view = PageOptionCircularView(option: .player)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOption(_:))))
        return view
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
        contentView.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            vStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    @objc func didTapOption(_ gestureRecognizer: UITapGestureRecognizer) {
        if let stackView = gestureRecognizer.view {
            switch stackView {
            case conductorStackView:
                didSelect?(.conductor)
            case sessionStackView:
                didSelect?(.session)
            case hallSoundStackView:
                didSelect?(.hallSound)
            case playerStackView:
                didSelect?(.player)
            default: break
            }
        }
    }
    
}
