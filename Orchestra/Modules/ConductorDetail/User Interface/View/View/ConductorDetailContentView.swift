//
//  ConductorDetailContentView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import UIKit

class ConductorDetailContentView: UIView {
    
    let title: String
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 9
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.text = title
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = "γγ«γΌγ"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        return label
    }()
    
    //MARK: Initializers
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        prepareLayout()
    }
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView()
    }
    
    func setValue(_ value: String?, _ japaneseValue: String? = nil) {
        let japanese = japaneseValue?.isEmpty ?? true ? "" : "\n\(japaneseValue ?? "")"
        valueLabel.text = "\(value ?? "")\(japanese)"
        isHidden = value?.isEmpty ?? true && japaneseValue?.isEmpty ?? true
    }
    
}
