//
//  RecordViewPopup.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/4/22.
//

import UIKit

class RecordViewPopup: UIView {
    
    //MARK: - UI Elements
    lazy var recordView: RecordCircleView = {
       let v = RecordCircleView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var headerLabel: UILabel = {
       let label = UILabel()
        label.text = LocalizedKey.startRecording.value
        label.font = .notoSansJPMedium(size: .size19)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = LocalizedKey.recordDescription.value
        label.font = .notoSansJPRegular(size: .size16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var lineView: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var cancelButton: UIButton = {
       let btn = UIButton()
        btn.setTitle(LocalizedKey.cancel.value, for: .normal)
        btn.titleLabel?.textColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var recordButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" \(LocalizedKey.rec.value)", for: .normal)
        btn.titleLabel?.font = .notoSansJPRegular(size: .size16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#DB0000").withAlphaComponent(0.69)
        btn.setImage(UIImage(systemName: "mic")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.isHidden = false
        btn.curve = 4
        return btn
    }()
    
    //MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor(hexString: "#000000CC", alpha: 0.8)
        backgroundColor = UIColor(hexString: "#000000").withAlphaComponent(0.9)
        
        configurationHeaderLabel()
        configureRecordSign()

        configureDescriptionLabel()
        configureLineView()
        configureCancelButton()
        configureRecordButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UI Configuration
    private func configureRecordSign() {
        addSubview(recordView)
        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
//            recordView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -60),
            recordView.heightAnchor.constraint(equalToConstant: 30),
            recordView.widthAnchor.constraint(equalToConstant: 30),
            recordView.trailingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: -11)
        ])
    }
    
    private func configurationHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//            headerLabel.leadingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: 11)
        ])
    }
    
    private func configureDescriptionLabel() {
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 13),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
    
    private func configureLineView() {
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func configureCancelButton() {
        addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            cancelButton.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20)
        ])
    }
    
    private func configureRecordButton() {
        addSubview(recordButton)
        NSLayoutConstraint.activate([
            recordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            recordButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            recordButton.widthAnchor.constraint(equalToConstant: 100),
            recordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
