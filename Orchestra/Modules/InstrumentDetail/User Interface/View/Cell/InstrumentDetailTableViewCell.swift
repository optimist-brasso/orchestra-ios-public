//
//  InstrumentDetailTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//

import UIKit
import Combine

class InstrumentDetailTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var  downloadState =  DownloadConstants.DownloadState.notDownloaded
    var viewModel: InstrumentDetailViewModel? {
        didSet {
            setData()
        }
    }
    var favourite: (() -> Void)?
    var organizationChart: (() -> Void)?
    var cancelDownload: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    private var bag = Set<AnyCancellable>()
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView,
                                                       bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
//    private lazy var playerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 210 / 390).isActive = true
//        view.backgroundColor = UIColor(hexString: "#C4C4C4")
//        return view
//    }()
//
//    private lazy var playImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "play-1"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: 47).isActive = true
//        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
//    private(set) lazy var backButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(UIImage(named: "back"), for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel,
                                                       separatorView,
                                                       instrumentStackView])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "English Title"
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "English Title"
        label.font = .appFont(type: .notoSansJP(.light), size: .size20)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var separatorView: PlayerSeperatorView = {
        let view = PlayerSeperatorView()
        return view
    }()
    
    private lazy var instrumentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instrumentLabel,
                                                       playerNameLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "B♭トランペット"
        label.font = .appFont(type: .notoSansJP(.light), size: .size18)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "B♭トランペット"
        label.font = .appFont(type: .notoSansJP(.light), size: .size18)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bottomView,
                                                       progressInfoStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var organizationChartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.curve = 2
        let attributedTitle = NSAttributedString(string: LocalizedKey.viewOrganizationChart.value, attributes: [.foregroundColor : UIColor.black,
                                                                               NSAttributedString.Key.font: UIFont.appFont(type: .notoSansJP(.thin), size: .size12),
                                                                                                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton,
                                                       cancelDownloadButton,
                                                       shareButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var favouriteButton: UIButton = {
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
//        button.setImage(GlobalConstants.Image.download, for: .normal)
        button.setImage(GlobalConstants.Image.stop, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        //        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.publisher(for: .touchUpInside)
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
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

    private lazy var lineSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#6A6A6A")
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
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        NSLayoutConstraint.activate([
//            playerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            detailStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 32)
        ])
        
//        contentView.addSubview(favouriteButton)
//        NSLayoutConstraint.activate([
//            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
//            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor),
//            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
//        ])
        
//        playerView.addSubview(playImageView)
//        NSLayoutConstraint.activate([
//            playImageView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
//            playImageView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
//        ])
        
//        contentView.addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14)
//        ])
        
        bottomView.addSubview(actionStackView)
        NSLayoutConstraint.activate([
            actionStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            actionStackView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
        
        bottomView.addSubview(organizationChartButton)
        NSLayoutConstraint.activate([
            organizationChartButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            organizationChartButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
        
        bottomStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -13).isActive = true
        
        contentView.addSubview(lineSeparatorView)
        NSLayoutConstraint.activate([
            lineSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lineSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setData() {
        titleLabel.text = viewModel?.orchestra?.title
        japaneseTitleLabel.text = viewModel?.orchestra?.titleJapanese
        japaneseTitleLabel.isHidden = viewModel?.orchestra?.titleJapanese?.isEmpty ?? true
        instrumentLabel.text = viewModel?.name
        organizationChartButton.isHidden = viewModel?.orchestra?.organizationDiagram?.isEmpty ?? true
        playerNameLabel.text = viewModel?.musician
        playerNameLabel.isHidden = viewModel?.musician?.isEmpty ?? true
        instrumentStackView.isHidden = (viewModel?.name?.isEmpty ?? true) && (viewModel?.musician?.isEmpty ?? true)
//        downloadButton.isHidden = downloadState != .downloading //viewModel?.isDownloaded ?? false
        favouriteButton.isSelected = viewModel?.isFavourite ?? false
    }
    
    @objc  private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case favouriteButton:
            favourite?()
        case organizationChartButton:
            organizationChart?()
        case cancelDownloadButton:
            cancelDownload?()
        case shareButton:
            shareButtonTapped?()
        default: break
        }
    }
    
}
