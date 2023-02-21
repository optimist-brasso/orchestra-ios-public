//
//  PlayerListCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//

import UIKit

class PlayerListCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var viewModel: PlayerListingViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properites
     private  func  thumbnailImageView() -> PlayerImage  {
        let imageView = PlayerImage(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func  detailView() -> UIView  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.65)
        return view
    }
    
    private func stackView() -> UIStackView  {
        let stackView = UIStackView() //(arrangedSubviews: [titleLabel,
                                                //   instrumentLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    private func  titleLabel() ->  UILabel {
        let label = UILabel()
        label.text = "窪⽥恵美"
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func  instrumentLabel() -> UILabel {
        let label = UILabel()
        label.text = "フルート"
        label.font = .appFont(type: .notoSansJP(.light), size: .size12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
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
       
    }
    
    private func setData() {
       // print(viewModel)
        remove()
        
        let thumbnailImageView = self.thumbnailImageView()
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        let stackView = self.stackView()
        let detailView = self.detailView()
        
        detailView.addSubview(stackView)
        let titleLabel = self.titleLabel()
        let instrumentLabel  = self.instrumentLabel()
        
        [titleLabel, instrumentLabel].forEach(stackView.addArrangedSubview(_:))
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
        
        titleLabel.text = viewModel?.name
        instrumentLabel.text = viewModel?.instrument
        instrumentLabel.isHidden = viewModel?.instrument?.isEmpty ?? true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.image = UIImage()
        let imageView = UIImageView()
        thumbnailImageView.startIndicator()
        imageView.showImageWithUrl(with: viewModel?.image, placeholderImage: nil, transition: .crossDissolve(1)) { [weak self] image, url in
            guard let self = self else { return }
            guard let image = image else  {
                thumbnailImageView.image = GlobalConstants.Image.playerThumbnailSmall
                thumbnailImageView.stopIndicator()
                thumbnailImageView.contentMode = .scaleAspectFill
                return
            }
            if image != GlobalConstants.Image.playerThumbnailSmall && url == self.viewModel?.image {
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
