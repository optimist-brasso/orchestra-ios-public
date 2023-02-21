//
//  PlayerListingScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class PlayerListingScreen: BaseScreen {
    
    // MARK: UI Properties
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(PlayerListCollectionViewCell.self)
        collectionView.registerCell(PlayerListOptionCollectionViewCell.self)
        collectionView.register(PlayerListCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    private(set) lazy var pointView: PointFloatingView = {
        let tableView = PointFloatingView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(collectionView)
        addSubview(pointView)
        collectionView.fillSuperView()
        
        NSLayoutConstraint.activate([
            pointView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            pointView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            pointView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
}
