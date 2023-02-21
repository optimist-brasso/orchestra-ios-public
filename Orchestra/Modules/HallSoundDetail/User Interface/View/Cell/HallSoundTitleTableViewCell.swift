//
//  HallSoundTitleTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import UIKit
import Combine

class HallSoundTitleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: HallSoundDetailViewModel? {
        didSet {
            setData()
        }
    }
    var buyTapped: (() -> Void)?
    var soundViewTapped: ((_ tag: String?) -> Void)?
    var favourite: ((Bool) -> Void)?
    var shareButtonTapped: (() -> Void)?
    var cancelDownload: (() -> Void)?
    private var bag = Set<AnyCancellable>()
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContainerView,
                                                       bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 218 / 387).isActive = true
        view.backgroundColor = UIColor(hexString: "#C4C4C4")
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "banner"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView,
                                                       buyContainerView,
                                                       soundStackView,
                                                       actionContainerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "English Title"
        label.textColor = .black
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .notoSansJPRegular(size: .size16)
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語表記の楽曲名"
        label.textColor = .black
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .notoSansJPRegular(size: .size20)
        return label
    }()
    
    private lazy var buyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.curve = 4
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        return button
    }()
    
    private lazy var soundStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftSoundView,
                                                      rightSoundView,
                                                      centerSoundView,
                                                      backSoundView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var centerSoundView: UIStackView = {
        let view = getSoundDirectionView(title: "C センター席")
        view.isHidden = true
        return view
    }()
    
    private lazy var rightSoundView: UIStackView = {
        let view = getSoundDirectionView(title: "R 右フロア席")
        view.isHidden = true
        return view
    }()
    
    private lazy var leftSoundView: UIStackView = {
        let view = getSoundDirectionView(title: "L 左フロア席")
        view.isHidden = true
        return view
    }()
    
    private lazy var backSoundView: UIStackView = {
        let view = getSoundDirectionView(title: "B バックフロア席")
        view.isHidden = true
        return view
    }()
    
    private lazy var actionContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actionContainerView,
                                                       progressInfoStackView])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private(set) lazy var progressInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [downloadingLabel,
                                                       progressView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var downloadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Downloading..."
        label.font = .notoSansJPMedium(size: .size16)
        return label
    }()
    
    private(set) lazy var progressView: UIProgressView = {
        let progessView = UIProgressView()
        progessView.translatesAutoresizingMaskIntoConstraints = false
        progessView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        progessView.progressTintColor = UIColor(hexString: "#0D6483")
        return progessView
    }()
    
    private lazy var actionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton,
                                                       cancelDownloadButton,
                                                       shareButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 14
        stackView.alignment = .center
        return stackView
    }()
    
    private(set) lazy var favouriteButton: UIButton = {
        let button = FavouriteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tintColor = UIColor(hexString: "#6A6969")
        return button
    }()
    
    private(set) lazy var cancelDownloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.stop, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.buttonTapped(button)
            }.store(in: &bag)
        button.isHidden = true
        button.tintColor = UIColor(hexString: "#6A6969")
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 19).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.setImage(GlobalConstants.Image.share, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#E7E7E7")
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
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: .zero, left: .zero, bottom: 13, right: .zero))
        
        imageContainerView.addSubview(thumbnailImageView)
        imageContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        thumbnailImageView.fillSuperView()
        
        bottomStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 14).isActive = true
        buyContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        soundStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 22).isActive = true
        actionContainerView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        
        buyContainerView.addSubview(buyButton)
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: buyContainerView.leadingAnchor, constant: 56),
            buyButton.centerXAnchor.constraint(equalTo: buyContainerView.centerXAnchor),
            buyButton.topAnchor.constraint(equalTo: buyContainerView.topAnchor, constant: 11),
            buyButton.bottomAnchor.constraint(equalTo: buyContainerView.bottomAnchor, constant: -11),
        ])
        
        actionContainerView.addSubview(actionStackView)
        NSLayoutConstraint.activate([
            actionStackView.trailingAnchor.constraint(equalTo: actionContainerView.trailingAnchor, constant: -14),
            actionStackView.topAnchor.constraint(equalTo: actionContainerView.topAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: actionContainerView.bottomAnchor)
        ])
        
        progressInfoStackView.leadingAnchor.constraint(equalTo: actionContainerStackView.leadingAnchor, constant: 14).isActive = true
        
        contentView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seperatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func getSoundDirectionView(title: String) -> UIStackView {
        let playImageView = UIImageView(image: GlobalConstants.Image.filledPlay)
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        playImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
//        titleLabel.text = title.replacingOccurrences(of: " ", with: "\n")
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = .notoSansJPLight(size: .size12)
        
        let stackView = UIStackView(arrangedSubviews: [playImageView,
                                                       titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }
    
    private func setData() {
        titleLabel.text = viewModel?.title
        titleLabel.isHidden = viewModel?.title?.isEmpty ?? true
        japaneseTitleLabel.text = viewModel?.titleJapanese
        japaneseTitleLabel.isHidden = viewModel?.titleJapanese?.isEmpty ?? true
        favouriteButton.isSelected = viewModel?.isFavourite ?? false
        thumbnailImageView.showImage(with: viewModel?.image)
        viewModel?.hallsounds?.enumerated().forEach({
            if !($0.element.audioLink?.isEmpty ?? true) {
                switch $0.offset {
                case .zero:
                    leftSoundView.isHidden = false
                    (leftSoundView.arrangedSubviews.element(at: 1) as? UILabel)?.text = $0.element.type
                case 1:
                    rightSoundView.isHidden = false
                    (rightSoundView.arrangedSubviews.element(at: 1) as? UILabel)?.text = $0.element.type
                case 2:
                    centerSoundView.isHidden = false
                    (centerSoundView.arrangedSubviews.element(at: 1) as? UILabel)?.text = $0.element.type
                case 3:
                    backSoundView.isHidden = false
                    (backSoundView.arrangedSubviews.element(at: 1) as? UILabel)?.text = $0.element.type
                default: break
                }
            }
        })
        let isBought = viewModel?.isBought ?? false
        soundStackView.isHidden = !isBought
        buyContainerView.isHidden = isBought
//        downloadButton.isHidden = !isBought || viewModel?.isDownloaded ?? false
        setupGestures()
    }
    
    private func setupGestures() {
        centerSoundView.arrangedSubviews.first?.tag = HallSoundDirection.centerFloor.rawValue
        rightSoundView.arrangedSubviews.first?.tag = HallSoundDirection.rightFloor.rawValue
        leftSoundView.arrangedSubviews.first?.tag = HallSoundDirection.leftFloor.rawValue
        backSoundView.arrangedSubviews.first?.tag = HallSoundDirection.backFloor.rawValue
        [centerSoundView,
         rightSoundView,
         leftSoundView,
         backSoundView].forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(openMiniPlayer(_:)))
            tap.numberOfTapsRequired = 1
            let view = $0.arrangedSubviews.first
            tap.view?.tag =  view?.tag ?? .zero
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(tap)
        }
    }
    
    @objc private func openMiniPlayer(_ sender: UITapGestureRecognizer) {
        guard let getTag = sender.view?.tag else { return }
//        print("getTag == \(getTag)")
        soundViewTapped?("\(getTag)")
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case favouriteButton:
            favourite?(sender.isSelected)
        case buyButton:
            buyTapped?()
        case cancelDownloadButton:
            cancelDownload?()
        case shareButton:
            shareButtonTapped?()
        default: break
        }
    }
    
}
