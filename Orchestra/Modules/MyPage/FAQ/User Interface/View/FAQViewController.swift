//
//  FAQViewController.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import UIKit

class FAQViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: FAQModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    override func loadView() {
        super.loadView()
        view = FAQView(frame: .zero, presenter: presenter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        view.backgroundColor = .white
    }
    
    // MARK: IBActions
    
    // MARK: Other Functions
    
    private func setup() {
        // all setup should be done here
    }
}

// MARK: FAQViewInterface
extension FAQViewController: FAQViewInterface {
    
}
