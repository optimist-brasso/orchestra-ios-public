//
//  SessionLayoutView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//

import UIKit

class SessionLayoutView: UIView {
    
    //MARK: - Properties
    var viewModel: SessionViewModel? {
        didSet {
            backgroundImage.showImage(with: viewModel?.image, placeholderImage: UIImage())
        }
    }
    var instrumentTapped: ((SessionLayoutViewModel) -> Void)?
    
    //MARK: - UI Element's
    lazy var innerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.2)
        return v
    }()
    
    lazy var backgroundImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var infoView: SessionLayoutInfoView = {
        let view = SessionLayoutInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var guestLoginView: SessionLayoutGuestView = {
        let view = SessionLayoutGuestView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    //MARK: Initialziers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureInnerView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UI Configuration
    private func configureInnerView() {
        addSubview(innerView)
        switch traitCollection.userInterfaceIdiom {
        case .phone:
            NSLayoutConstraint.activate([
                innerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                innerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        case .pad:
            let height = UIScreen.screenHeight - 50
            let width = UIScreen.screenWidth
            let heightReaminder = height.truncatingRemainder(dividingBy: GlobalConstants.AspectRatio.sessionBackground.width)
            let widthRemainder = width.truncatingRemainder(dividingBy: GlobalConstants.AspectRatio.sessionBackground.height)
            if widthRemainder <= heightReaminder {
                innerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                innerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            } else {
                innerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
                innerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        default: break
        }
        
        NSLayoutConstraint.activate([
            innerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerView.widthAnchor.constraint(equalTo: innerView.heightAnchor, multiplier: GlobalConstants.AspectRatio.sessionBackground.width / GlobalConstants.AspectRatio.sessionBackground.height)
        ])
        
        addSubview(infoView)
        infoView.fillSuperView()
        
        addSubview(guestLoginView)
        NSLayoutConstraint.activate([
            guestLoginView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            guestLoginView.centerXAnchor.constraint(equalTo: centerXAnchor),
            guestLoginView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    //MARK: Other functions
    private func configureBackgroundImage() {
        innerView.addSubview(backgroundImage)
        //        backgroundImage.showImage(with: "https://www.dictionary.com/e/wp-content/uploads/2015/10/1000x700_symphony_orchestra_jpg_71Fax2n0-790x310.jpg")
        backgroundImage.fillSuperView()
    }
    
    private func configureInstruments(with data: [SessionLayoutViewModel]) {
        data.forEach { model in
            let v = InstrumentView(frame: .init(x: model.x,
                                                y: model.y,
                                                width: model.width,
                                                height: model.height))
            v.translatesAutoresizingMaskIntoConstraints = false
            v.viewTapped = { [weak self] in
                self?.instrumentTapped?(model)
            }
            innerView.addSubview(v)
            v.layer.borderWidth = deploymentMode == .qa ? 2 : .zero
            v.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: model.x).isActive = true
            v.topAnchor.constraint(equalTo: innerView.topAnchor, constant: model.y).isActive = true
            v.widthAnchor.constraint(equalToConstant: model.width).isActive = true
            v.heightAnchor.constraint(equalToConstant: model.height).isActive = true
            if model.instrument?.isBought ?? false {
                let imageView = UIImageView(image: GlobalConstants.Image.purchased?.setTemplate())
                imageView.tintColor = .white
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                v.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: v.topAnchor),
                    imageView.centerXAnchor.constraint(equalTo: v.centerXAnchor)
                ])
            }
        }
        updateConstraintsIfNeeded()
    }
    
    func setupData(with data: SessionViewModel) {
        configureBackgroundImage()
        viewModel = data
        configureInstruments(with: data.layouts ?? [])
    }
    
}

