//
//  PlayerListOptionCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//

import UIKit

class PlayerListOptionCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var selectedPage: OrchestraType? {
        didSet {
            var imageView: UIView?
            var titleLabel: UIView?
            switch selectedPage {
            case .conductor:
                titleLabel = conductorStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = conductorStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
            case .session:
                titleLabel = sessionStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = sessionStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
            case .hallSound:
                titleLabel = hallSoundStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = hallSoundStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
            case .player:
                titleLabel = playerStackView.stackView.arrangedSubviews.filter({$0 is UILabel}).first
                imageView = playerStackView.stackView.arrangedSubviews.filter({$0 is UIImageView}).first
            default: break
            }
            let selectedColor = UIColor(hexString: "#0D6483")
            (titleLabel as? UILabel)?.textColor = selectedColor
            imageView?.set(borderWidth: 4, of: selectedColor)
        }
    }
    var didSelect: ((OrchestraType) -> ())?
    
    //MARK: UI Properties
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
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
