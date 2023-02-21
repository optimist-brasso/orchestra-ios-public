//
//  SeperatorView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import UIKit.UIView

class SeperatorView: UIView {
    
    //MARK: UI Propeties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leadingView, seperatorView, trailingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var leadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.backgroundColor = UIColor(hexString: "#B2964E")
        return view
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#B2964E")
        return view
    }()
    
    private lazy var trailingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.backgroundColor = UIColor(hexString: "#B2964E")
        return view
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView()
    }
    
}
