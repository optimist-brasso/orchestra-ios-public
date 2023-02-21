//
//  ConductorDetailTitleTableView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import UIKit
import Combine

class ConductorDetailTitleTableView: UITableViewCell {
    
    //MARK: Properties
    var downloadState =  DownloadConstants.DownloadState.notDownloaded
    var viewModel: ConductorDetailViewModel? {
        didSet {
            setData()
        }
    }
    var organizationChart: (() -> Void)?
    var favourite: (() -> Void)?
    var cancelDownload: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    private var bag = Set<AnyCancellable>()
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [conductorLabel,
                                                       titleLabel,
                                                       actionContainerStackView,
                                                       descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 11
        return stackView
    }()
    
    private lazy var conductorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 110).isActive = true
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        label.text = "Conductor"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.textColor = UIColor(hexString: "#0D6483")
        label.textAlignment = .center
        label.curve = 4
        label.set(borderWidth: 2, of: UIColor(hexString: "#2C6380"))
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording/ゲンバンヒョウキ"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        return label
    }()
    
    private lazy var actionContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actionView,
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
    
    private lazy var actionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var organizationChartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 67).isActive = true
        button.curve = 2
        button.setTitle(LocalizedKey.viewOrganizationChart.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size9)
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
//        button.setImage(GlobalConstants.Image.download, for: .normal)
        button.setImage(GlobalConstants.Image.stop, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
        button.widthAnchor.constraint(equalToConstant: 17).isActive = true
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.setImage(GlobalConstants.Image.share, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 11, left: 25, bottom: .zero, right: 14))
        
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
        actionView.addSubview(actionStackView)
        NSLayoutConstraint.activate([
            actionStackView.trailingAnchor.constraint(equalTo: actionView.trailingAnchor),
            actionStackView.topAnchor.constraint(equalTo: actionView.topAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: actionView.bottomAnchor)
        ])
        
        actionView.addSubview(organizationChartButton)
        NSLayoutConstraint.activate([
            organizationChartButton.leadingAnchor.constraint(equalTo: actionView.leadingAnchor),
            organizationChartButton.centerYAnchor.constraint(equalTo: actionView.centerYAnchor)
        ])
        
        actionContainerStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }

    private func setData() {
        titleLabel.text = viewModel?.title?.replacingOccurrences(of: "/", with: "\n")
        descriptionLabel.text = viewModel?.description
        descriptionLabel.isHidden = viewModel?.description?.isEmpty ?? true
        organizationChartButton.isHidden = viewModel?.organizationDiagram?.isEmpty ?? true
        favouriteButton.isSelected = viewModel?.isFavourite ?? false
//        downloadButton.isHidden =  (viewModel?.vrFile?.isEmpty ?? true) || viewModel?.isDownloaded ?? false || downloadState != .downloading
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case organizationChartButton:
            organizationChart?()
        case favouriteButton:
            favourite?()
        case cancelDownloadButton:
            cancelDownload?()
        case shareButton:
            shareButtonTapped?()
        default: break
        }
    }
    
}
