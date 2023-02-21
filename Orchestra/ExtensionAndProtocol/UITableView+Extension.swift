//
//  UITableView.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit

extension UIView {
    static var identifier: String {
        "\(self)"
    }
}


extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass.identifier))
    }
    
    func registerNibCell<T: UITableViewCell>(_ cell: T.Type) {
        //self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass.identifier))
        self.register(UINib(nibName: String(describing: cell.identifier), bundle: .main), forCellReuseIdentifier: String(describing: cell.identifier))
    }
    
    func registerHeader<T: UITableViewHeaderFooterView>(_ view: T.Type) {
        self.register(view, forHeaderFooterViewReuseIdentifier: view.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(String(describing: T.self))")
        }
        return cell
    }
    
    
    func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
    
    func dequeue<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)") as! T
    }
    func dequeue<T: UITableViewHeaderFooterView>(_ view: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: view.identifier) as! T 
    }
    
    
    func showEmpty(with title: String = LocalizedKey.noData.value) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: .zero, y: .zero, width: bounds.size.width, height: bounds.size.height))
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
//        noDataLabel.backgroundColor = .yellow
        noDataLabel.text = title
        noDataLabel.numberOfLines = .zero
        noDataLabel.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        noDataLabel.textColor = .black
        noDataLabel.textAlignment = .center
        backgroundView = noDataLabel
        NSLayoutConstraint.activate([
            noDataLabel.widthAnchor.constraint(equalTo: widthAnchor),
            noDataLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
}

extension UIView {
    
    func fillSuperView(inset: UIEdgeInsets = .zero) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: inset.left).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: inset.top).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -inset.right).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -inset.bottom).isActive = true
    }
    
}
