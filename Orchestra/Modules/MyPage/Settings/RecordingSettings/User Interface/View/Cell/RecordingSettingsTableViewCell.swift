//
//  RecordingSettingsTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//

import UIKit

class RecordingSettingsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var recordingSettings: RecordingSetting? {
        didSet {
            titleLabel.text = recordingSettings?.title
        }
    }
//    var title: String?
//    var values: [String]?
    var currentValue: String? {
        didSet {
            valueLabel.text = currentValue
            index = recordingSettings?.values?.firstIndex(where: {$0 == currentValue}) ?? .zero
        }
    }
    private var index: Int = .zero {
        didSet {
            setupPrevNextButton()
        }
    }
    var select: ((String?) -> ())?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       incrementView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()
    
    private lazy var incrementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.leftRoundedArrow, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.rightRoundedArrow, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D0D0D0").withAlphaComponent(0.6)
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 18, left: 26, bottom: 18, right: 23))
        
        contentView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        incrementView.addSubview(previousButton)
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: incrementView.leadingAnchor),
            previousButton.centerYAnchor.constraint(equalTo: incrementView.centerYAnchor)
        ])
        
        incrementView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: incrementView.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: incrementView.centerYAnchor)
        ])
        
        incrementView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: incrementView.trailingAnchor),
            nextButton.centerYAnchor.constraint(equalTo: incrementView.centerYAnchor)
        ])
    }
    
    private func setupPrevNextButton() {
        previousButton.isEnabled = index > .zero
        nextButton.isEnabled = index < (recordingSettings?.values?.count ?? .zero) - 1
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case previousButton:
            index -= 1
        case nextButton:
            index += 1
        default: break
        }
        currentValue = recordingSettings?.values?.element(at: index)
        select?(currentValue)
    }
    
}
