//
//  record_playerViewController.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import UIKit

class record_playerViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: record_playerModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: IBActions
    
    // MARK: Other Functions
    
    private func setup() {
        // all setup should be done here
    }
}

// MARK: record_playerViewInterface
extension record_playerViewController: record_playerViewInterface {
    
}
