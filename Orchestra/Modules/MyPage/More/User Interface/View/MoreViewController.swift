//
//  MoreViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class MoreViewController: BaseViewController {
    
    enum Row: Int, CaseIterable {
        case tutorial,
             aboutApp,
             faq,
             opinionRequest,
             officialWebsite
        
        var title: String? {
            switch self {
            case .tutorial:
                return LocalizedKey.tutorial.value
            case .aboutApp:
                return LocalizedKey.aboutApp.value
            case .faq:
                return LocalizedKey.faq.value
            case .opinionRequest:
                return LocalizedKey.opinionRequest.value
            case .officialWebsite:
                return LocalizedKey.officialWebsite.value
            }
        }
    }
    
    // MARK: Properties
    private  var screen: MoreScreen  {
        baseScreen as! MoreScreen
    }
    
    var presenter: MoreModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
    }
    
}

// MARK: MyPageContentViewInterface
extension MoreViewController: MoreViewInterface {
    
}

// MARK: MyPageContentViewInterface
extension MoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.title = Row(rawValue: indexPath.row)?.title
        return cell
    }
    
}

// MARK: MyPageContentViewInterface
extension MoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .tutorial:
                presenter?.onboarding()
            case .aboutApp:
                presenter?.navigateToAboutApp()
            case .faq:
                presenter?.navigateToFAQ()
            case .opinionRequest:
                presenter?.navigateToOpinionRequest()
            case .officialWebsite:
                presenter?.navigateToOfficialSite()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue(cellForRowAt: IndexPath(row: .zero, section: section))
        cell.title = LocalizedKey.more.value
        return cell.contentView
    }
    
}
