//
//  SettingsViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class SettingsViewController: BaseViewController {
    
    enum Row: Int, CaseIterable {
        case streamingDownload,
            // recording,
             dataManagement,
             pushNotification,
             //imageQualityUponLowSpeed,
             appVersionInformation
        
        var title: String? {
            switch self {
            case .streamingDownload:
                return LocalizedKey.stramingDownload.value
//            case .recording:
//                return LocalizedKey.recording.value
            case .dataManagement:
                return LocalizedKey.dataManagement.value
            case .pushNotification:
                return LocalizedKey.pushNotification.value
           // case .imageQualityUponLowSpeed:
               // return LocalizedKey.imageQualityUponLowSpeed.value
            case .appVersionInformation:
                return LocalizedKey.appVersionInformation.value
            }
        }
    }
    
    // MARK: Properties
    private  var screen: SettingsScreen  {
        baseScreen as! SettingsScreen
    }
    
    var presenter: SettingsModuleInterface?
    private var viewModel: SettingsViewModel? {
        didSet {
            screen.tableView.reloadData()
        }
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
        setupView()
    }
    
    private func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
    }
    
    private func setupView() {
        screen.dataManagementView.onTap = { [weak self] in
            self?.presenter?.dataManagementSettings()
        }
        screen.streamingDownloadView.onTap = { [weak self] in
            self?.presenter?.streamingDownloadSettings()
        }
        screen.pushNotificationView.switchEnabled = { [weak self] enable in
            self?.presenter?.toggleNotificationStatus()
        }
    }
    
}

// MARK: SettingsViewInterface
extension SettingsViewController: SettingsViewInterface {
    
    func show(_ model: SettingsViewModel) {
//        viewModel = model
        screen.appVersionView.detail = model.version
        screen.pushNotificationView.enabled = model.notificationStatus
        screen.pushNotificationView.isHidden = !model.isLoggedIn
    }
    
    func show(toggle: Bool) {
        screen.pushNotificationView.enabled = toggle
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}

// MARK: MyPageContentViewInterface
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .pushNotification:
                return configure(tableView, cellForRowAt: indexPath) as SwitchTableViewCell
            default:
                return configure(tableView, cellForRowAt: indexPath) as MyPageTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MyPageTableViewCell {
        let cell: MyPageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        let row = Row(rawValue: indexPath.row)
        cell.title = row?.title
        if row == .appVersionInformation {
            cell.detail = viewModel?.version
            cell.allowNavigation = false
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SwitchTableViewCell {
        let cell: SwitchTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if let row = Row(rawValue: indexPath.row) {
            cell.title = row.title
            if row == .pushNotification {
                cell.enabled = viewModel?.notificationStatus
                cell.switchEnabled = { [weak self] enable in
                    self?.presenter?.toggleNotificationStatus()
                }
            }
        }
        return cell
    }
    
}

// MARK: MyPageContentViewInterface
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue(cellForRowAt: IndexPath(row: .zero, section: section))
        cell.title = LocalizedKey.settings.value
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .streamingDownload:
                presenter?.streamingDownloadSettings()
//            case .recording:
//                presenter?.recordingSettings()
            case .dataManagement:
                presenter?.dataManagementSettings()
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let row = Row(rawValue: indexPath.row),
           row == .pushNotification,
           !(viewModel?.isLoggedIn ?? false) {
            return .zero
        }
        return UITableView.automaticDimension
    }
    
}
