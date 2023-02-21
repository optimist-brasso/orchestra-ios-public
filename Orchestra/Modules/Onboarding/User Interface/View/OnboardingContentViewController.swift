//
//  OnboardingContentViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 06/04/2022.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    
    // MARK: - Properties
    var index = 0
    var heading = ""
    var subHeading1 = ""
    var subHeading2 = ""
    var imageFile = ""
    
    //MARK: IBOutlets
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var subHeading1Label: UILabel!
    @IBOutlet var subHeading2Label: UILabel!
    @IBOutlet var contentImageView: UIImageView!

    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        [headingLabel,
         subHeading1Label,
         subHeading2Label].forEach({
            $0?.numberOfLines = .zero
        })
        contentImageView.layer.cornerRadius = 8
        headingLabel.text = heading
        subHeading1Label.text = subHeading1
        subHeading2Label.text = subHeading2
        contentImageView.image = UIImage(named: imageFile)
    }

}


class NewOnboardingController: UIViewController {
    
    var openRegister: (() -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.registerCell(OnboardingCollectionViewCell.self)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = data.count
        pageControl.pageIndicatorTintColor = .init(hexString: "#C9CACA")
        pageControl.currentPageIndicatorTintColor = .init(hexString: "#C9A063")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setAttributedTitle("SKIP".attributeText(attribute: [.font: UIFont.boldSystemFont(ofSize: 17).boldItalics(), .foregroundColor: UIColor.init(hexString: "#C9A063")] ), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(register(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var presenter: OnboardingModuleInterface? 
    let data = OnboardingItem.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func prepareLayout() {
        [collectionView,
         pageControl,
         button].forEach(view.addSubview(_:))
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func register(_ sender: UIButton) {
        openRegister?()
        Cacher().setValue(true, key: .isAppPreviouslyOpen)
    }
    
}

//MARK: UICollectionViewDataSource
extension NewOnboardingController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : OnboardingCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.model = data[indexPath.item]
        return cell
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension NewOnboardingController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentPageValue(offset: scrollView.contentOffset.x)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCurrentPageValue(offset: scrollView.contentOffset.x)
    }
    
    func setCurrentPageValue(offset: CGFloat) {
        let offset =  offset / collectionView.frame.width
        pageControl.currentPage = Int(offset)
        pageControl.isHidden = pageControl.currentPage == data.count - 1
        button.isHidden = pageControl.currentPage != data.count - 1
    }
    
}

//MARK: OnboardingViewInterface
extension NewOnboardingController: OnboardingViewInterface {
    
}

enum OnboardingItem: CaseIterable {
    case first
    case second
    case third
    case forth
    case fifth
    case sixth
    case seventh
    
    var background: UIImage? {
        switch self {
        case .first, .fifth, .sixth:
            return .bg_1//.background_1
        case .second:
            return .bg_2
        case .third:
            return .bg_3
        case .forth:
            return .bg_4
        case .seventh:
            return .bg_7
        }
    }
    
    var base: UIImage? {
        switch self {
        case .first:
            return .frame_1 //.base_1
        case .second:
            return .frame_2
        case .third:
            return .frame_3
        case .forth:
            return .frame_4
        case .fifth:
            return .frame_5
        case .sixth:
            return .frame_6
        case .seventh:
            return .frame_7
        }
    }
    
    var text: UIColor? {
        switch self {
        case .first:
            return  .init(hexString: "#00607C")
        case .second:
            return .white
        case .third:
            return .white
        case .forth:
            return .white
        case .fifth, .sixth :
            return .init(hexString: "#000000")
        case .seventh:
            return nil
        }
    }
}


extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {

        // create a new font descriptor with the given traits
        guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
            // the given traits couldn't be applied, return self
            return self
        }
            
        // return a new font with the created font descriptor
        return UIFont(descriptor: fd, size: pointSize)
    }

    func italics() -> UIFont {
        return withTraits(.traitItalic)
    }

    func bold() -> UIFont {
        return withTraits(.traitBold)
    }

    func boldItalics() -> UIFont {
        return withTraits([ .traitBold, .traitItalic ])
    }

}
