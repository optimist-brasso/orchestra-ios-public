//
//  PlayerInfoView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerInfoView: UIView {
    
    //MARK: Properies
    let title: String
    
    //MARK: UI Propeties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "熊代 祐子"
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
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
