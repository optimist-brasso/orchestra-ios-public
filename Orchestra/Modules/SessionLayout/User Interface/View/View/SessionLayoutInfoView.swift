//
//  SessionLayoutInfoView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//

import UIKit

class SessionLayoutInfoView: UIView {
    
    //MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        return view
    }()
    
    private lazy var infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.curve = 20
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.text = "タップして\n楽器を選択してください"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hand"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(containerView)
        containerView.fillSuperView()
        
        containerView.addSubview(infoContainerView)
        NSLayoutConstraint.activate([
            infoContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            infoContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        infoContainerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor)
        ])
        
        infoContainerView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            iconImageView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -30),
            iconImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -15),
            iconImageView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func viewTapped() {
        removeFromSuperview()
    }
    
}
