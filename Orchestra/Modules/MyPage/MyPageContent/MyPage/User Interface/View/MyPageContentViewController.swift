//
//  MyPageContentViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class MyPageContentViewController: BaseViewController {
    
    enum Row: Int, CaseIterable {
        case profile,
             changePassword,
             purchasedListContent,
         //    recordingList,
             billingHistory,
          //   buyPoint,
             logout,
             withdrawl
        
        var title: String? {
            switch self {
            case .profile:
                return LocalizedKey.profile.value
            case .changePassword:
                return LocalizedKey.changePassword.value
            case .purchasedListContent:
                return LocalizedKey.purchasedListContent.value
//            case .recordingList:
//                return LocalizedKey.recordingList.value
            case .billingHistory:
                return LocalizedKey.pointPurchaseHistory.value
           // case .buyPoint:
              //  return LocalizedKey.points.value
            case .logout:
                return LocalizedKey.logout.value
            case .withdrawl:
                return LocalizedKey.withdrawl.value
            }
        }
    }
    
    // MARK: Properties
    private var screen: MyPageContentScreen  {
        baseScreen as! MyPageContentScreen
    }
    
    var presenter: MyPageContentModuleInterface?
    private var isLoggedIn: Bool = false
    private var isSocialLoggedIn: Bool = false
    
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
extension MyPageContentViewController: MyPageContentViewInterface {
    
    func showLoggedIn(status: Bool) {
        isLoggedIn = status
    }
    
    func showSocialLogin(status: Bool) {
        isSocialLoggedIn = status
//        if status {
//            screen.tableView.reloadRows(at: [IndexPath(row: Row.changePassword.rawValue, section: .zero)], with: .none)
//        }
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}

// MARK: MyPageContentViewInterface
extension MyPageContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .logout:
                cell.title = isLoggedIn ? row.title : LocalizedKey.login.value
            default:
                cell.title = row.title
            }
        }
        return cell
    }
    
}

// MARK: MyPageContentViewInterface
extension MyPageContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MyPageHeaderTableViewCell.self)") as? MyPageHeaderTableViewCell
        cell?.title = LocalizedKey.myPage.value
        return cell?.contentView ?? UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .profile:
                presenter?.profile()
            case .changePassword:
                presenter?.openChangePassword()
//            case .recordingList:
//                presenter?.recordingList()
            case .purchasedListContent:
                presenter?.purchasedContentList()
            case .billingHistory:
                presenter?.openBillingHistory()
//            case .buyPoint:
//                presenter?.buyPoint()
            case .logout:
                if !isLoggedIn {
                    presenter?.login()
                    return
                }
                presenter?.logout()
            case .withdrawl:
                presenter?.withdraw()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let row = Row(rawValue: indexPath.row) {
            if row == .logout {
                return UITableView.automaticDimension
            }
            if row == .changePassword {
                return isLoggedIn && !isSocialLoggedIn ? UITableView.automaticDimension : .zero
            }
            return isLoggedIn ? UITableView.automaticDimension : .zero
        }
        return .zero
    }
    
}
