//
//  StreamingDownloadSettingsViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class StreamingDownloadSettingsViewController: BaseViewController {
    
    enum Row: Int, CaseIterable {
        case notifyUsingMobileData,
             downloadOverWifiOnly
//        case streamingQuality,
//             streamingPlaybackOverWifiOnly,
//             spacer,
//             downloadQuality,
//             automaticDownload
        
        var title: String? {
            switch self {
//            case .streamingQuality:
//                return LocalizedKey.streamingQuality.value
//            case .streamingPlaybackOverWifiOnly:
//                return LocalizedKey.streamingPlaybackOverWifiOnly.value
            case .notifyUsingMobileData:
                return LocalizedKey.notifyUsingMobileData.value
//            case .downloadQuality:
//                return LocalizedKey.downloadQuality.value
            case .downloadOverWifiOnly:
                return LocalizedKey.downloadOverWifiOnly.value
//            case .automaticDownload:
//                return LocalizedKey.automaticDownload.value
//            case .spacer:
//                return nil
            }
        }
        
//        var height: CGFloat {
//            switch self {
//            case .streamingPlaybackOverWifiOnly,
//                    .streamingQuality,
//                    .downloadQuality,
//                    .automaticDownload,
//                    .spacer:
//                return .zero
//            default: return UITableView.automaticDimension
//            }
//        }
    }
    
    // MARK: Properties
    private  var screen: StreamingDownloadSettingsScreen  {
        baseScreen as! StreamingDownloadSettingsScreen
    }
    
    var presenter: StreamingDownloadSettingsModuleInterface?
    private var viewModel: StreamingDownloadSettingsViewModel? {
        didSet {
            if oldValue == nil {
                screen.tableView.reloadData()
            }
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
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
    }
    
}

// MARK: StreamingDownloadSettingsViewInterface
extension StreamingDownloadSettingsViewController: StreamingDownloadSettingsViewInterface {
    
    func show(_ model: StreamingDownloadSettingsViewModel) {
        viewModel = model
    }
    
}

// MARK: MyPageContentViewInterface
extension StreamingDownloadSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let row = Row(rawValue: indexPath.row) {
            switch row {
//            case .spacer:
//                return tableView.dequeue(cellForRowAt: indexPath) as SpacerTableViewCell
//            case .streamingPlaybackOverWifiOnly,
                case .notifyUsingMobileData,
                    .downloadOverWifiOnly:
                return configure(tableView, cellForRowAt: indexPath) as SwitchTableViewCell
//            default:
//                return configure(tableView, cellForRowAt: indexPath) as MyPageTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MyPageTableViewCell {
        let cell: MyPageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        let row = Row(rawValue: indexPath.row)
        cell.title = row?.title
//        var detail: String?
//        if row == .streamingQuality {
//            detail = "中"
//        } else if row == .downloadQuality {
//            detail = "高"
//        } else if row == .automaticDownload {
//            detail = "有効"
//        }
//        cell.detail = detail
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SwitchTableViewCell {
        let cell: SwitchTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        let row = Row(rawValue: indexPath.row)
        cell.title = row?.title
        cell.switchEnabled = { [weak self] isEnabled in
            switch row {
                //                case .streamingPlaybackOverWifiOnly:
                //                    viewModel.wifiStreamingOnly = isEnabled
            case .notifyUsingMobileData:
                self?.viewModel?.mobileDataNotify = isEnabled
                print("I am here")
            case .downloadOverWifiOnly:
                self?.viewModel?.wifiDownloadOnly = isEnabled
                print("I am here")
            default: break
            }
            guard let viewModel = self?.viewModel else { return }
            self?.presenter?.submit(viewModel)
        }
        switch row {
//        case .streamingPlaybackOverWifiOnly:
//            cell.settingsSwitch.isOn = viewModel?.wifiStreamingOnly ?? false
        case .notifyUsingMobileData:
            cell.settingsSwitch.isOn = viewModel?.mobileDataNotify ?? false
        case .downloadOverWifiOnly:
            cell.settingsSwitch.isOn = viewModel?.wifiDownloadOnly ?? false
        default: break
        }
        return cell
    }
    
}

// MARK: MyPageContentViewInterface
extension StreamingDownloadSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue()
        cell.title = LocalizedKey.stramingDownload.value
        return cell.contentView
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let row = Row(rawValue: indexPath.row) {
//            return row.height
//        }
//        return .zero
//    }
    
}
