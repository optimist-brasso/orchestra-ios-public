//
//  CountdownView.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/5/22.
//

import UIKit

class CountdownView: UIView {
    
    //MARK: Properties
    var timer: Timer?
    var timerStopped: (() -> Void)?
    var counter: Int = 3
    
    //MARK: - UI Elements
    lazy var headerLabel: UILabel = {
       let label = UILabel()
        label.text = "録音開始カウント"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .notoSansJPMedium(size: .size19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var dottedView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
     
        return v
    }()
    
    lazy var counterLabel: UILabel = {
       let label = UILabel()
        label.text = "\(counter)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 96)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(hexString: "#000000").withAlphaComponent(0.9)
        
        //configuration
        configureHeaderLabel()
        configureDottedView()
        configureCounterLabel()
        
        //timer configuration
        startTimer()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dottedView.addDashedCircle()
    }
    
    
    //MARK: - UI Configuration
    
    private func configureHeaderLabel() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 34),
            
        ])
    }
    
    private func configureDottedView() {
        addSubview(dottedView)
        NSLayoutConstraint.activate([
            dottedView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            dottedView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dottedView.heightAnchor.constraint(equalToConstant: 140),
            dottedView.widthAnchor.constraint(equalToConstant: 140),
            dottedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -34)
        ])
    }
    
    private func configureCounterLabel() {
        addSubview(counterLabel)
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: dottedView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: dottedView.centerYAnchor)
        ])
    }

    
    //MARK: - Private Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
   
            self.counter -= 1
            if self.counter == 0 {
                timer.invalidate()
                self.timerStopped?()
                return
            }
            self.counterLabel.text = "\(self.counter)"
          
        })

    }
    

}
