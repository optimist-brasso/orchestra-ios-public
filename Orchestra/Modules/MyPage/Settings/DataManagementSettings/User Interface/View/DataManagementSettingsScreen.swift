//
//  DataManagementSettingsScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class DataManagementSettingsScreen: BaseScreen {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView,
                                                      scrollView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        view.heightAnchor.constraint(equalToConstant: 43).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.dataManagement.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var listStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cacheDataView,
                                                       cacheUsageCapacityView,
                                                       deleteCacheView,
                                                       downloadSongsView,
                                                       downloadCompleteView,
                                                       spaceUsageCapacityView,
                                                       freeSpaceView,
                                                       deleteDownloadView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var cacheDataView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.cacheData.value)
        return view
    }()
    
    private(set) lazy var cacheUsageCapacityView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.capacityUsed.value, value: "150.50 MB")
        return view
    }()
    
    private lazy var deleteCacheView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteCacheStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cacheInfoLabel,
                                                       deleteCacheButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var cacheInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.text = LocalizedKey.cacheInfo.value
        label.font = .appFont(type: .notoSansJP(.light), size: .size12)
        return label
    }()
    
    private(set) lazy var deleteCacheButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setTitle(LocalizedKey.deleteCache.value, for: .normal)
        button.titleLabel?.font = .notoSansJPRegular(size: .size12)
        button.backgroundColor = UIColor(hexString: "#464646")
        button.setTitleColor(.white, for: .normal)
        button.curve = 15
        return button
    }()
    
    private lazy var downloadSongsView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.downloadSongs.value)
        return view
    }()
    
    private(set) lazy var downloadCompleteView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.downloadComplete.value, value: "10 曲")
        return view
    }()
    
    private(set) lazy var spaceUsageCapacityView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.capacityUsed.value, value: "51.24 MB")
        return view
    }()
    
    private(set) lazy var freeSpaceView: DataManagementSettingsView = {
        let view = DataManagementSettingsView(title: LocalizedKey.freeSpace.value, value: "2.81 GB")
        return view
    }()
    
    private lazy var deleteDownloadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var deleteDownloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setTitle(LocalizedKey.deleteDownloadData.value, for: .normal)
        button.titleLabel?.font = .notoSansJPRegular(size: .size12)
        button.backgroundColor = UIColor(hexString: "#464646")
        button.setTitleColor(.white, for: .normal)
        button.curve = 15
        return button
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(stackView)
        stackView.fillSuperView()
        
        scrollView.addSubview(containerView)
        containerView.fillSuperView()
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
//        containerView.addSubview(titleView)
//        NSLayoutConstraint.activate([
//            titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            titleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            titleView.topAnchor.constraint(equalTo: containerView.topAnchor)
//        ])
        
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        containerView.addSubview(listStackView)
        NSLayoutConstraint.activate([
            listStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            listStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            listStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            listStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        deleteCacheView.addSubview(deleteCacheStackView)
        NSLayoutConstraint.activate([
            cacheInfoLabel.leadingAnchor.constraint(equalTo: deleteCacheStackView.leadingAnchor),
            deleteCacheButton.leadingAnchor.constraint(equalTo: deleteCacheStackView.leadingAnchor, constant: 57)
        ])
        deleteCacheStackView.fillSuperView(inset: UIEdgeInsets(top: 10, left: 18, bottom: 31, right: 18))
        
        deleteDownloadView.addSubview(deleteDownloadButton)
        deleteDownloadButton.fillSuperView(inset: UIEdgeInsets(top: 23, left: 75, bottom: 23, right: 75))
    }
    
}
