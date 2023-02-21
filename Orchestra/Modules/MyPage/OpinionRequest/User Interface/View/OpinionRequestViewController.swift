//
//  OpinionRequestViewController.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/22/22.
//
//

import UIKit

class OpinionRequestViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: OpinionRequestModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    
    override func loadView() {
        super.loadView()
        view = OpinionRequestView(frame: .zero, presenter: presenter)
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

// MARK: OpinionRequestViewInterface
extension OpinionRequestViewController: OpinionRequestViewInterface {
    
}
