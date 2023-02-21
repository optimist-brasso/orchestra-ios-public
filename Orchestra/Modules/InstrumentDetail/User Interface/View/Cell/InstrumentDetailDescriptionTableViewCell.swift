//
//  InstrumentDetailDescriptionTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//

import UIKit

class InstrumentDetailDescriptionTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: InstrumentDetailOrchestraViewModel? {
        didSet {
            setData()
        }
    }
    var otherOption: ((OrchestraType) -> ())?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView,
                                                       detailStackView,
                                                       businessRestructuringView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "リリース記念！表示価格の20％０FF"
        label.textColor = UIColor(hexString: "#900000")
        label.font = .notoSansJPBold(size: .size17)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "リリース記念！表示価格の20％０FF"
        label.textColor = UIColor(hexString: "#900000")
        label.font = .notoSansJPLight(size: .size14)
        label.numberOfLines = .zero
        label.textAlignment = .justified
        return label
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [composerView,
                                                       orchestraNameView,
                                                       conductorView,
                                                       organizationView,
                                                       venueNameView,
                                                       lapView,
                                                       releaseDateView,
                                                       jasracLiscenceNumberView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var composerView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.composer.value)
        return view
    }()
    
    private lazy var orchestraNameView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.orchestraName.value)
        return view
    }()
    
    private lazy var conductorView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.conductorTitle.value)
        return view
    }()
    
    private lazy var organizationView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.organization.value)
        return view
    }()
    
    private lazy var venueNameView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.venueName.value)
        return view
    }()
    
    private lazy var lapView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.playTime.value)
        return view
    }()
    
    private lazy var releaseDateView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.releaseDate.value)
        return view
    }()
    
    private lazy var jasracLiscenceNumberView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.liscenceNumber.value)
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var businessRestructuringButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 27).isActive = true
//        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
//        button.setTitle("R2 事業再構築", for: .normal)
//        button.titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size14)
//        button.setTitleColor(UIColor(hexString: "#757575"), for: .normal)
//        button.set(of: UIColor(hexString: "#757575"))
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titlePadding = 12
//        button.titleLabel?.lineBreakMode = .byWordWrapping
//        button.curve = 4
//        return button
//    }()
    
    private lazy var businessRestructuringView: BusinessTypeView = {
        let view = BusinessTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        return view
    }()
    
//    private lazy var buttonStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [conductorButton,
//                                                      hallSoundButton,
//                                                      playerButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        stackView.spacing = 12
//        return stackView
//    }()
//
//    private lazy var conductorButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.setTitle("Conductor", for: .normal)
//        button.backgroundColor = UIColor(hexString: "#0D6483")
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        button.curve = 8
//        return button
//    }()
//
//    private lazy var hallSoundButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setTitle("Hall Sound", for: .normal)
//        button.backgroundColor = UIColor(hexString: "#0D6483")
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        button.curve = 8
//        return button
//    }()
//
//    private lazy var playerButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setTitle("Player", for: .normal)
//        button.backgroundColor = UIColor(hexString: "#0D6483")
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16) ?? .italicSystemFont(ofSize: 16)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        button.curve = 8
//        return button
//    }()
    
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
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38)
        ])
        
        contentView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 6),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        bottomView.addSubview(businessRestructuringView)
        NSLayoutConstraint.activate([
            businessRestructuringView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 31),
            businessRestructuringView.trailingAnchor.constraint(lessThanOrEqualTo: bottomView.trailingAnchor, constant: -16),
            businessRestructuringView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            businessRestructuringView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -23)
        ])
        
//        bottomView.addSubview(buttonStackView)
//        NSLayoutConstraint.activate([
//            buttonStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 31),
//            buttonStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
//            buttonStackView.topAnchor.constraint(equalTo: businessRestructuringView.bottomAnchor, constant: 55),
//            buttonStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -23)
//        ])
    }
    
    private func setData() {
        let composers = viewModel?.composer?.components(separatedBy: ",")
        composerView.setValue(composers?.first?.trimmingCharacters(in: .whitespaces),
                              composers?.count ?? .zero >= 2 ? composers?.last?.trimmingCharacters(in: .whitespaces) : nil)
        let conductors = viewModel?.conductor?.components(separatedBy: ",")
        conductorView.setValue(conductors?.first?.trimmingCharacters(in: .whitespaces),
                               conductors?.count ?? .zero >= 2 ? conductors?.last?.trimmingCharacters(in: .whitespaces) : nil)
        let venues = viewModel?.venueTitle?.components(separatedBy: ",")
        venueNameView.setValue(venues?.first?.trimmingCharacters(in: .whitespaces),
                               venues?.count ?? .zero >= 2 ? venues?.last?.trimmingCharacters(in: .whitespaces) : nil)
        lapView.setValue(viewModel?.duration)
        releaseDateView.setValue(viewModel?.releaseDate)
        organizationView.setValue(viewModel?.organization)
//        businessRestructuringButton.setTitle(viewModel?.businessType, for: .normal)
//        businessRestructuringButton.isHidden = viewModel?.businessType?.isEmpty ?? true
        businessRestructuringView.setValue(viewModel?.businessType)
        businessRestructuringView.isHidden = viewModel?.businessType?.isEmpty ?? true
        orchestraNameView.setValue(viewModel?.band)
        jasracLiscenceNumberView.setValue(viewModel?.liscenceNumber)
    }
    
//    @objc private func buttonTapped(_ sender: UIButton) {
//        switch sender {
//        case conductorButton:
//            otherOption?(.conductor)
//        case hallSoundButton:
//            otherOption?(.hallSound)
//        case playerButton:
//            otherOption?(.player)
//        default: break
//        }
//    }
    
}
