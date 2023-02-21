//
//  InstrumentBuyScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

import UIKit

class BulkInstrumentBuyConfirmationScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var confirmationView: InstrumentBuyConfirmationView = {
        let view = InstrumentBuyConfirmationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var successView: InstrumentBuySuccessView = {
        let view = InstrumentBuySuccessView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        backgroundColor = .clear
        
        addSubview(confirmationView)
        NSLayoutConstraint.activate([
            confirmationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            confirmationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(successView)
        NSLayoutConstraint.activate([
            successView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            successView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
