//
//  OfficialSiteViewController.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWALon 6/23/22.
//
//

import UIKit

class OfficialSiteViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: OfficialSiteModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    override func loadView() {
        super.loadView()
        view = OfficialSiteView(frame: .zero, presenter: presenter)
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

// MARK: OfficialSiteViewInterface
extension OfficialSiteViewController: OfficialSiteViewInterface {
    
}
