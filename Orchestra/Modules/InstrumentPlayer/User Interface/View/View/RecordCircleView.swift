//
//  RecordCircleView.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/4/22.
//

import UIKit

class RecordCircleView: UIView {
    
    //MARK: - UI Elements
    lazy var whiteCircleView: UIView = {
       let v = UIView()
        v.curve = 15
        v.set(borderWidth: 2, of: .white)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var redView: UIView = {
       let v = UIView()
        v.backgroundColor = .red
        v.curve = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Intializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //configuration
        configureWhiteCircleView()
        configureRedView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI Configuration
    private func configureWhiteCircleView() {
        addSubview(whiteCircleView)
        NSLayoutConstraint.activate([
            whiteCircleView.heightAnchor.constraint(equalToConstant: 30),
            whiteCircleView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureRedView() {
        addSubview(redView)
        NSLayoutConstraint.activate([
            redView.centerXAnchor.constraint(equalTo: whiteCircleView.centerXAnchor),
            redView.centerYAnchor.constraint(equalTo: whiteCircleView.centerYAnchor),
            redView.heightAnchor.constraint(equalToConstant: 20),
            redView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    //MARK: Private Methods
    func startAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.redView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        }, completion: nil)
    }
}
