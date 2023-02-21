////
////  SortingScreen.swift
////  Orchestra
////
////  Created by manjil on 09/11/2022.
////
//
//import UIKit
//
//
//class SortingButton: UIButton {
//    override var isSelected: Bool {
//        didSet {
//            backgroundColor = isSelected ? .black : .white
//            setTitleColor(isSelected ? .white : .black, for: .normal)
//            
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layer.cornerRadius = 5
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1
//        layer.masksToBounds = true
//    }
//}
//
//class SortingScreen: BaseScreen {
//     
//    private lazy var topButtonStack: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.spacing = 40
//        stack.distribution = .fillEqually
//        return stack
//    }()
//    
//    private(set) lazy var sortingButton: SortingButton = {
//        let button = SortingButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("ソート", for: .normal)
//        return button
//    }()
//    
//    private(set) lazy var filterButton: SortingButton = {
//        let button = SortingButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("フィルター", for: .normal)
//        return button
//    }()
//    
//    
//    override func create() {
//        super.create()
//        
//        addSubview(topButtonStack)
//        topButtonStack.addArrangedSubview(sortingButton)
//        topButtonStack.addArrangedSubview(filterButton)
//    }
//    
//}
