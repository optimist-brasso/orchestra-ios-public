//
//  FavouritePlayerCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//

import UIKit

class FavouritePlayerCollectionViewCell: UICollectionViewCell {
    
    struct Constant {
        static let playerImageAspectRatio: (width: CGFloat, height: CGFloat) = (width: 130, height: 165)
    }
    
    //MARK: Properties
    var data: FavouritePlayer! {
        didSet {
            if data != nil {
                configurationCell()
            }
        }
    }
    var makeUnfavourite: ((_ id: Int) -> Void)?
    
    //MARK: UI Properites
    public func  thumbnailImageView() -> PlayerImage {
        let imageView = PlayerImage(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constant.playerImageAspectRatio.height / Constant.playerImageAspectRatio.width).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func detailView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.65)
        return view
    }
    
    private func stackView() -> UIStackView  {
        let stackView = UIStackView()  //UIStackView(arrangedSubviews: [nameLabel,
        //instrumentLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    private func nameLabel() ->  UILabel  {
        let label = UILabel()
        label.text = "窪⽥恵美"
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func instrumentLabel() -> UILabel {
        let label = UILabel()
        label.text = "フルート"
        label.font = .appFont(type: .notoSansJP(.light), size: .size12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func favouriteButton() ->  UIButton  {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.favourite, for: .normal)
        button.tintColor = UIColor(hexString: "#6A6969")
        button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return button
    }
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func configurationCell() {
        /// remove old layout
        remove()
        /// prepare layout
        let thumbnailImageView = thumbnailImageView()
        let stackView = stackView()
        let detailView = detailView()
        let favouriteButton = favouriteButton()
        let instrumentLabel = instrumentLabel()
        let nameLabel = nameLabel()
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        
        [nameLabel, instrumentLabel].forEach(stackView.addArrangedSubview(_:))
        
        detailView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 8),
            stackView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 4),
            stackView.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
        ])
        
        contentView.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
        
        ///  set data
        nameLabel.text = data.title
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.image = nil
        let imageView = UIImageView()
        thumbnailImageView.startIndicator()
        
        imageView.showImage(with: data.image, placeholderImage: nil, transition: .crossDissolve(1)) {  image in
            guard let image = image else  {
                thumbnailImageView.image = GlobalConstants.Image.playerThumbnailSmall
                thumbnailImageView.stopIndicator()
                thumbnailImageView.contentMode = .scaleAspectFill
                return
            }
            if image != GlobalConstants.Image.playerThumbnailSmall {
                thumbnailImageView.contentMode = .top
                let width = thumbnailImageView.frame.size.width
                let photo = image.resized(width * 1.5)
                thumbnailImageView.image = photo
            } else {
                thumbnailImageView.image = image
                thumbnailImageView.contentMode = .scaleAspectFill
            }
            thumbnailImageView.stopIndicator()
        }
        
        instrumentLabel.text = data.instrument?.name
        instrumentLabel.isHidden = data.instrument?.name?.isEmpty ?? true
    }
    
    @objc private func action(_ sender: UIButton) {
        makeUnfavourite?(data.id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        remove()
    }
    
    private func remove() {
        contentView.subviews.forEach( {
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
}
