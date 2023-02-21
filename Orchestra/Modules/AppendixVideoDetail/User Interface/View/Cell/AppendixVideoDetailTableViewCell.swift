//
//  IndexVideoDetailTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//

import UIKit
import Combine

class AppendixVideoDetailTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var premiumContents: String?
    var isBought = false
    
    struct Constant {
        static let maxLines = 3
    }
    var  downloadState =  DownloadConstants.DownloadState.notDownloaded
    var viewModel: AppendixVideoDetailViewModel? {
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
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel,
                                                       separatorView,
                                                       instrumentLabel])
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
    
    private lazy var instrumentLabel: UILabel = {
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
        button.publisher(for: .touchUpInside)
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.buttonTapped(button)
            }.store(in: &bag)
        //        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPLight(size: .size14)
        label.numberOfLines = Constant.maxLines
        label.textAlignment = .justified
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
        contentView.backgroundColor = .clear
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
//        contentView.addSubview(favouriteButton)
//        NSLayoutConstraint.activate([
//            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
//            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor),
//            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
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
        detailStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 32).isActive = true
        
        contentView.addSubview(lineSeparatorView)
        NSLayoutConstraint.activate([
            lineSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lineSeparatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
//            lineSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: lineSeparatorView.bottomAnchor,constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: lineSeparatorView.leadingAnchor,constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: lineSeparatorView.trailingAnchor,constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setData() {
        titleLabel.text = viewModel?.orchestra?.title
        japaneseTitleLabel.text = viewModel?.orchestra?.titleJapanese
        japaneseTitleLabel.isHidden = viewModel?.orchestra?.titleJapanese?.isEmpty ?? true
        instrumentLabel.text = viewModel?.instrument
        organizationChartButton.isHidden = viewModel?.orchestra?.organizationDiagram?.isEmpty ?? true
//        downloadButton.isHidden = (viewModel?.premiumFile?.isEmpty ?? true) || viewModel?.isDownloaded ?? false || downloadState != .downloading
        favouriteButton.isSelected = viewModel?.isFavourite ?? false
        
        descriptionLabel.numberOfLines = isBought ? .zero : Constant.maxLines
        descriptionLabel.text = premiumContents
        descriptionLabel.isHidden = premiumContents?.isEmpty ?? true
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
