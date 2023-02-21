//
//  InstrumentView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/5/22.
//

import UIKit

//enum InstrumentType {
//    case piano
//    case drum
//    case clarinet
//    case bass
//    case violin
//    case flute
//}


class InstrumentView: UIView {
    
    //MARK: - Properties
    var viewTapped: (() -> Void)?
    var isSelected: Bool = false
    
    //MARK: UI Elements
    lazy var instrumentImage: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInstrumentImage()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UI Configuration
    private func configureInstrumentImage() {
        addSubview(instrumentImage)
        instrumentImage.fillSuperView()
    }
    
    //MARK: - Methods
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapp))
        addGestureRecognizer(tapGesture)
    }
        
    //MARK: - Objc Methods
    @objc private func viewTapp() {
        viewTapped?()
//        isSelected.toggle()
//        //        layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.black.cgColor
//        if isSelected {
//            viewTapped?()
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
//                guard let self = self else { return }
////                self.layer.borderColor = UIColor.red.cgColor
//                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            } completion: { [weak self] _ in
//                guard let self = self else { return }
//                self.transform = .identity
//            }
//        }
////        else {
////            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
////                guard let self = self else { return }
////                self.layer.borderColor = UIColor.black.cgColor
////                self.transform = .identity
////            } completion: { _ in
////
////            }
////        }
    }
}
