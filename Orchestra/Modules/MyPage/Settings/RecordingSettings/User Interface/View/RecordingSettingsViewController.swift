//
//  RecordingSettingsViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class RecordingSettingsViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: RecordingSettingsScreen  {
        baseScreen as! RecordingSettingsScreen
    }
    
    var presenter: RecordingSettingsModuleInterface?
    private var viewModel: RecordingSettingsViewModel? {
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
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
    }
    
}

// MARK: RecordingSettingsViewInterface
extension RecordingSettingsViewController: RecordingSettingsViewInterface {
    
    func show(_ model: RecordingSettingsViewModel) {
        viewModel = model
    }
    
}

// MARK: MyPageContentViewInterface
extension RecordingSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordingSetting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecordingSettingsTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
//        let row = Row.allCases.element(at: indexPath.row)
//        cell.title = row?.title
//        cell.values = row?.values
        let row = RecordingSetting.allCases.element(at: indexPath.row)
        cell.recordingSettings = row
        var currentValue: String?
        switch row {
        case .fileFormat:
            currentValue = viewModel?.fileFormat
//        case .encodingQuality:
//            currentValue = viewModel?.encodingQuality
        case .samplingRate:
            currentValue = viewModel?.samplingRate
        case .bitRate:
            currentValue = viewModel?.bitRate
//        case .channel:
//            currentValue = viewModel?.channel
        default: break
        }
        cell.currentValue = currentValue ?? row?.values?.element(at: .zero)
        cell.select = { [weak self] value in
            self?.presenter?.select(value: value, of: row)
        }
        return cell
    }
    
}

// MARK: MyPageContentViewInterface
extension RecordingSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue(cellForRowAt: IndexPath(row: .zero, section: section))
        cell.title = LocalizedKey.recording.value
        return cell.contentView
    }
    
}
