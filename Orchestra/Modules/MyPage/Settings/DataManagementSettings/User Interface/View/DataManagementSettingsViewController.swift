//
//  DataManagementSettingsViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class DataManagementSettingsViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: DataManagementSettingsScreen  {
        baseScreen as! DataManagementSettingsScreen
    }
    
    var presenter: DataManagementSettingsModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        presenter?.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewIsReady()
    }
    
    // MARK: Other Functions
    private func setup() {
        setupButton()
    }
    
    private func setupButton() {
        [screen.deleteCacheButton,
         screen.deleteDownloadButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.deleteCacheButton:
            alertWithOkCancel(message: LocalizedKey.deleteCacheWarning.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, okStyle: .default, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
                self?.presenter?.deleteCache()
            }, cancelAction: nil)
        case screen.deleteDownloadButton:
            alertWithOkCancel(message: LocalizedKey.deleteDownloadWarning.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, okStyle: .default, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
                self?.presenter?.deleteDownload()
            }, cancelAction: nil)
        default: break
        }
    }
    
}

// MARK: DataManagementSettingsViewInterface
extension DataManagementSettingsViewController: DataManagementSettingsViewInterface {
    
    func show(_ model: DataManagementSettingsViewModel) {
        screen.cacheUsageCapacityView.set(model.cacheSize)
        screen.downloadCompleteView.set("\(model.downloadCompleteCount ?? .zero) \(LocalizedKey.songs.value)")
        screen.spaceUsageCapacityView.set(model.capcityUsed)
        screen.freeSpaceView.set(model.freeSpace)
    }
    
}
