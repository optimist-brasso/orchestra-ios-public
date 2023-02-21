//
//  HallSoundDescriptionTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import UIKit

class HallSoundDescriptionTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: HallSoundDetailViewModel? {
        didSet {
            setData()
        }
    }
    var pageOption: ((OrchestraType) -> ())?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [venueStackView,
                                                       seperatorView,
                                                       songTitleStackView,
                                                       songDetailStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var venueStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [venueTitleLabel,
                                                       venueDescriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var venueTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .notoSansJPRegular(size: .size18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var venueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .notoSansJPLight(size: .size16)
        return label
    }()
    
    private lazy var seperatorView: UIView = {
        let view = SeperatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var songTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songTitleLabel,
                                                       songJapaneseTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "English Title"
        label.numberOfLines = .zero
        label.font = .notoSansJPRegular(size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var songJapaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語表記の楽曲名"
        label.numberOfLines = .zero
        label.font = .notoSansJPRegular(size: .size20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var songDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [composerView,
                                                       orchestraView,
                                                       conductorView,
                                                       organizationView,
                                                       venueView,
                                                       lapView,
                                                       releaseDateView,
                                                       lisceneNumberView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var composerView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.composer.value)
        return view
    }()
    
    private lazy var orchestraView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.orchestraName.value)
        return view
    }()
    
    private lazy var conductorView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.conductorTitle.value)
        return view
    }()
    
    private lazy var organizationView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.organization.value)
        return view
    }()
    
    private lazy var venueView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.venueName.value)
        return view
    }()
    
    private lazy var lapView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.playTime.value)
        return view
    }()
    
    private lazy var releaseDateView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.releaseDate.value)
        return view
    }()
    
    private lazy var lisceneNumberView: HallSoundContentView = {
        let view = HallSoundContentView(title: LocalizedKey.liscenceNumber.value)
        return view
    }()
    
//    private lazy var businessRestructuringButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 27).isActive = true
//        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
//        button.setTitle("R2 事業再構築", for: .normal)
//        button.titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size14)
//        button.setTitleColor(UIColor(hexString: "#757575"), for: .normal)
//        button.set(of: UIColor(hexString: "#757575"))
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titlePadding = 12
//        button.curve = 4
//        return button
//    }()
    
    private lazy var businessRestructuringView: BusinessTypeView = {
        let view = BusinessTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [conductorButton,
                                                       sessionButton,
                                                       playerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var sessionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setTitle("Session", for: .normal)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.curve = 8
        return button
    }()
    
    private lazy var conductorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Conductor", for: .normal)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.curve = 8
        return button
    }()
    
    private lazy var playerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Player", for: .normal)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.curve = 8
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
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        venueStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        seperatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12).isActive = true
        songTitleStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 2).isActive = true
        songDetailStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 2).isActive = true
        
        contentView.addSubview(businessRestructuringView)
        NSLayoutConstraint.activate([
            businessRestructuringView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            businessRestructuringView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -18),
            businessRestructuringView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8)
        ])
        
        contentView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: businessRestructuringView.leadingAnchor),
//            businessRestructuringView.trailingAnchor.constraint(lessThanOrEqualTo: bottomView.trailingAnchor, constant: -16),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: businessRestructuringView.bottomAnchor, constant: 23),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setData() {
        if let venue = viewModel?.venue {
            let array = venue.components(separatedBy: ",")
            venueTitleLabel.text = array.joined(separator: "\n")
            venueTitleLabel.numberOfLines = 0
        }
        venueTitleLabel.isHidden = viewModel?.venue?.isEmpty ?? true
        venueDescriptionLabel.text = viewModel?.venueDescription
        venueDescriptionLabel.isHidden = viewModel?.venueDescription?.isEmpty ?? true
        [venueStackView, seperatorView].forEach({
            $0.isHidden = viewModel?.venue?.isEmpty ?? true && viewModel?.venueDescription?.isEmpty ?? true
        })
        songTitleLabel.text = viewModel?.title
        songJapaneseTitleLabel.text = viewModel?.titleJapanese
        let composers = viewModel?.composer?.components(separatedBy: ",")
        composerView.setValue(composers?.first?.trimmingCharacters(in: .whitespaces),
                              composers?.count ?? .zero >= 2 ? composers?.last?.trimmingCharacters(in: .whitespaces) : nil)
        orchestraView.setValue(viewModel?.band)
        let conductors = viewModel?.conductor?.components(separatedBy: ",")
        conductorView.setValue(conductors?.first?.trimmingCharacters(in: .whitespaces),
                               conductors?.count ?? .zero >= 2 ? conductors?.last?.trimmingCharacters(in: .whitespaces) : nil)
        organizationView.setValue(viewModel?.organization)
        let venues = viewModel?.venue?.components(separatedBy: ",")
        venueView.setValue(venues?.first?.trimmingCharacters(in: .whitespaces),
                           venues?.count ?? .zero >= 2 ? venues?.last?.trimmingCharacters(in: .whitespaces) : nil)
        lapView.setValue(viewModel?.duration)
        releaseDateView.setValue(viewModel?.releaseDate)
        lisceneNumberView.setValue(viewModel?.liscenceNumber)
        
        businessRestructuringView.setValue(viewModel?.businessType)
        businessRestructuringView.isHidden = viewModel?.businessType?.isEmpty ?? true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case conductorButton:
            pageOption?(.conductor)
        case sessionButton:
            pageOption?(.session)
        case playerButton:
            pageOption?(.player)
        default: break
        }
    }
    
}
