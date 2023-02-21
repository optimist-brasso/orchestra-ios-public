//
//  RetakePopupView.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/14/22.
//

import UIKit


class RetakePopupView: UIView {
    
    //MARK: - Properties
    var retakeViewTapped: (() -> Void)?
    var confirmViewTapped: (() -> Void)?
    
    //MARK: - UI Element
    let uploadLabel = UILabel()
    lazy var loader: UIActivityIndicatorView = {
       let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        loader.isHidden = true
        loader.style = .large
        loader.color = .white
        return loader
    }()
    
    lazy var bgView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        return v
    }()
    
    lazy var retakeView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#000000").withAlphaComponent(0.6)
        v.curve = 6
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "撮り直しする"
        label.font = .notoSansJPMedium(size: .size19)
        label.textAlignment = .center
        label.textColor = .white
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        return v
    }()
    
    lazy var uploadView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#000000").withAlphaComponent(0.6)
        v.curve = 6
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadLabel.text = "確認する"
        uploadLabel.font = .notoSansJPMedium(size: .size19)
        uploadLabel.textAlignment = .center
        uploadLabel.textColor = .white
        v.addSubview(uploadLabel)
        NSLayoutConstraint.activate([
            uploadLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            uploadLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        v.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        return v
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //configuration
        configureBackgroundView()
        configureRetakeView()
        configureUploadView()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI Configuration
    private func configureBackgroundView() {
        addSubview(bgView)
        bgView.fillSuperView()
    }
    
    private func configureRetakeView() {
        bgView.addSubview(retakeView)
        NSLayoutConstraint.activate([
            retakeView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            retakeView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -125),
            retakeView.heightAnchor.constraint(equalToConstant: 100),
            retakeView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureUploadView() {
        bgView.addSubview(uploadView)
        NSLayoutConstraint.activate([
            uploadView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            uploadView.leadingAnchor.constraint(equalTo: retakeView.trailingAnchor, constant: 50),
            uploadView.heightAnchor.constraint(equalToConstant: 100),
            uploadView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func addTapGesture() {
        let retakeTap = UITapGestureRecognizer(target: self, action: #selector(retakeAudio))
        retakeView.addGestureRecognizer(retakeTap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(uploadAudio))
        uploadView.addGestureRecognizer(confirmTap)
    }
    
    //MARK: - Objc Methods
    @objc private func retakeAudio() {
        retakeViewTapped?()
    }
    
    @objc private func uploadAudio() {
        confirmViewTapped?()
    }
    
    func startLoader() {
        loader.isHidden = false
        loader.startAnimating()
        uploadLabel.isHidden = true
        uploadView.isUserInteractionEnabled = false
    }
    
    func hideLoader() {
        loader.isHidden = true
        loader.stopAnimating()
        uploadLabel.isHidden = false
        uploadView.isUserInteractionEnabled = true
    }
    
}
