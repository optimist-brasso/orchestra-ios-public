//
//  CustomSearchBar.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit.UISearchBar

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var getText: String {
        text ?? ""
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        barTintColor = .clear
        searchBarStyle = .minimal
        textField?.returnKeyType = .search
        textField?.backgroundColor = .white
        textField?.borderStyle = .none
        textField?.textColor = .black
        textField?.font = .appFont(type: .notoSansJP(.regular), size: .size10)
        if let leftView = textField?.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = .black
        }
        let toolbar = UIToolbar(frame: CGRect(x: .zero,
                                              y: .zero,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44))//1
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))//3
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        textField?.inputAccessoryView = toolbar
    }
    
    @objc func tapDone() {
        textField?.resignFirstResponder()
    }
    
}

extension UISearchBar {
    
    var textField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
    
}
