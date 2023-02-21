//
//  PlayerImageTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerImageTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var images: [String]? {
        didSet {
            pageControl.numberOfPages = images?.count ?? .zero
            pageControl.isHidden = images?.count ?? .zero < 2
            collectionView.reloadData()
        }
    }
//    var name: String? {
//        didSet {
//            nameLabel.text = name
//        }
//    }
    var back: (() -> ())?
    
    //MARK: UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(PlayerImageCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#0D6483")
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false 
        return pageControl
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mukesh Shakya"
        label.textColor = .white
        label.font = .appFont(type: .notoSansJP(.thin), size: .size42)
        label.textAlignment = .right
        label.numberOfLines = .zero
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let height = ((533 / 405) * contentView.frame.width) - 80
//        let width = name?.height(with: height, font: .appFont(type: .notoSansJP(.thin), size: .size42)) ?? .zero
//        nameLabel.frame = CGRect(x: 15, y: 40, width: width + 1, height: height)
//    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(collectionView)
        collectionView.fillSuperView()
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 3 / 2).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 533 / 405).isActive = true
        
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
        ])
        
//        nameLabel.transform = CGAffineTransform(rotationAngle: .pi / 2)
//        contentView.addSubview(nameLabel)
//
    }
    
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

//MARK: UICollectionViewDataSource
extension PlayerImageTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlayerImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
//        cell.profileImageView.image = UIImage(named: "player_profile\(indexPath.item)")
        cell.image = images?.element(at: indexPath.item)
        return cell
    }
    
}

//MARK: UICollectionViewDelegate
extension PlayerImageTableViewCell: UICollectionViewDelegate {
    
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension PlayerImageTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}


//MARK: UIScrollViewDelegate
extension PlayerImageTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
