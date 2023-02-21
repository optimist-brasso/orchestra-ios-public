//
//  HomeBannerTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit
import FSPagerView

class HomeBannerTableViewCell: UITableViewCell {
    
    struct Constant {
        static let aspectRatio: (width: CGFloat, height: CGFloat) = (392, 171)
        static let totalOffset: CGFloat = 96
        static let verticalMargin: CGFloat = 16
    }
    
    //MARK: Properties
    var viewModels: [HomeBannerViewModel]? {
        didSet {
            pagerView.reloadData()
        }
    }
    var details: (((url: String?, image: String?, title: String?, description: String?)) -> ())?
    
    //MARK: UI Properties
    private lazy var pagerView: FSPagerView = {
        let view = FSPagerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let height = UIScreen.main.bounds.width * (Constant.aspectRatio.height / Constant.aspectRatio.width)
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.backgroundColor = .clear
        view.isInfinite = true
        view.itemSize = CGSize(width: UIScreen.main.bounds.width - Constant.totalOffset, height: height - Constant.verticalMargin)
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        view.dataSource = self
        view.delegate = self
        view.automaticSlidingInterval = 3
        view.interitemSpacing = 27
        return view
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 12).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.leftArrowThin, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 12).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.rightArrowThin, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: Initilializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#F6F6F6")
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(pagerView)
        pagerView.fillSuperView()
        
        contentView.addSubview(previousButton)
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            previousButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            nextButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        var nextPage = sender == previousButton ? pagerView.currentIndex - 1 : pagerView.currentIndex + 1
        if nextPage >= viewModels?.count ?? .zero {
            nextPage = .zero
        }
        pagerView.scrollToItem(at: nextPage, animated: true)
        pagerView.automaticSlidingInterval = 3
    }
    
}

//MARK: FSPagerViewDataSource
extension HomeBannerTableViewCell: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModels?.count ?? .zero
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.showImage(with: viewModels?.element(at: index)?.image)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.curve = 12
        return cell
    }
    
}

//MARK: FSPagerViewDelegate
extension HomeBannerTableViewCell: FSPagerViewDelegate {
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        [previousButton, nextButton].forEach({
            $0.isHidden = true
        })
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        [previousButton, nextButton].forEach({
            $0.isHidden = false
        })
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        [previousButton, nextButton].forEach({
            $0.isHidden = false
        })
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let viewModel = viewModels?.element(at: index)
        details?((viewModel?.url, viewModel?.image, viewModel?.title, viewModel?.description))
    }
    
}
