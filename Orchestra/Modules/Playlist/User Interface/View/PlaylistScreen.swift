//
//  PlaylistScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import UIKit

class PlaylistScreen: BaseScreen {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchContainerView,
                                                       segmentedControl,
                                                       scrollView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 58).isActive = true
        return view
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar,
                                                       buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 35
        stackView.alignment = .center
        return stackView
    }()
    
    private(set) lazy var searchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar()
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        customSearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        customSearchBar.curve = 15
        customSearchBar.set(borderWidth: 1, of: UIColor(hexString: "#D5D5D5"))
        customSearchBar.placeholder = LocalizedKey.searchPlaceholder.value
        return customSearchBar
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupButton,
                                                       filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var groupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.group, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.filter, for: .normal)
        button.isHidden = true 
        return button
    }()
    
    private(set) lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Conductor",
                                                          "Session",
                                                          "Hall Sound"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 43).isActive = true
        segmentedControl.backgroundColor = UIColor(hexString: "#F2F2F2")
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.removeBorders()
        let font: UIFont = .boldItalicFont
        segmentedControl.setTitleTextAttributes([.font: font,
                                                 .foregroundColor: UIColor(hexString: "#888888")], for: .normal)
        segmentedControl.setTitleTextAttributes([.font: font,
                                                 .foregroundColor: UIColor(hexString: "#0D6483")], for: .selected)
        segmentedControl.clipsToBounds = false
        return segmentedControl
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints  = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private(set) lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = .zero
        return stack
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        searchContainerView.addSubview(searchStackView)
        searchStackView.fillSuperView(inset: UIEdgeInsets(top: 14, left: 26, bottom: 14, right: 25))
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        scrollView.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
