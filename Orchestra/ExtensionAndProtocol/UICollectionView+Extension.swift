//
//  UICollectionView.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit


extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.identifier))
    }
    
    func registerNibCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell.identifier), bundle: .main), forCellWithReuseIdentifier: String(describing: cell.identifier))
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(String(describing: "\(T.self)")) with reuseId of \(String(describing: T.self))")
        }
        return cell
    }

    func register<T: UICollectionReusableView>(_ cellClass: T.Type, forSupplementaryViewOfKind kind: String) {
        register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(T.self)")
    }
    
    func dequeue<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }
    
    func showEmpty(with title: String = LocalizedKey.noData.value) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: .zero, y: .zero, width: bounds.size.width, height: bounds.size.height))
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
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
