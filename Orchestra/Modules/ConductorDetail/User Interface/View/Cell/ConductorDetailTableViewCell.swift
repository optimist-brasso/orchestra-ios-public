//
//  ConductorDetailTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import UIKit

class ConductorDetailTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: ConductorDetailViewModel? {
        didSet {
            setData()
        }
    }
    var otherOption: ((OrchestraType) -> ())?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView,
                                                       bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [composerView,
                                                       bandNameView,
                                                       conductorView,
                                                       organizationView,
                                                       venueNameView,
                                                       lapView,
                                                       releaseDateView,
                                                       jasracLiscenceNumberView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var composerView: ConductorDetailContentView = {
        let view = ConductorDetailContentView(title: LocalizedKey.composer.value)
        return view
    }()
    
    private lazy var bandNameView: ConductorDetailContentView = {
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
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [businessRestructuringView,
                                                       buttonStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 13
        return stackView
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
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sessionButton,
                                                      hallSoundButton,
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
    
    private lazy var hallSoundButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Hall Sound", for: .normal)
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
        backgroundColor = .clear
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 14, left: 25, bottom: 14, right: 14))
        
        buttonStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case sessionButton:
            otherOption?(.session)
        case hallSoundButton:
            otherOption?(.hallSound)
        case playerButton:
            otherOption?(.player)
        default: break
        }
    }
    
    private func setData() {
        let composers = viewModel?.composer?.components(separatedBy: ",")
        composerView.setValue(composers?.first?.trimmingCharacters(in: .whitespaces),
                              composers?.count ?? .zero >= 2 ? composers?.last?.trimmingCharacters(in: .whitespaces) : nil)
        let conductors = viewModel?.conductor?.components(separatedBy: ",")
        conductorView.setValue(conductors?.first?.trimmingCharacters(in: .whitespaces),
                               conductors?.count ?? .zero >= 2 ? conductors?.last?.trimmingCharacters(in: .whitespaces) : nil)
        let venues = viewModel?.venue?.components(separatedBy: ",")
        venueNameView.setValue(venues?.first?.trimmingCharacters(in: .whitespaces),
                               venues?.count ?? .zero >= 2 ? venues?.last?.trimmingCharacters(in: .whitespaces) : nil)
        lapView.setValue(viewModel?.duration)
        releaseDateView.setValue(viewModel?.releaseDate)
        organizationView.setValue(viewModel?.organization)
        businessRestructuringView.setValue(viewModel?.businessType)
        businessRestructuringView.isHidden = viewModel?.businessType?.isEmpty ?? true
        bandNameView.setValue(viewModel?.band)
        jasracLiscenceNumberView.setValue(viewModel?.liscenceNumber)
    }
    
}
