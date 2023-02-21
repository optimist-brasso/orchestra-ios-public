//
//  OrchestraPlayerListScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import UIKit

class OrchestraPlayerListScreen: BaseScreen {
    
    // MARK: UI Properties
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(OrchestraPlayerListCollectionViewCell.self)
        return collectionView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(collectionView)
        collectionView.fillSuperView()
    }
    
}
