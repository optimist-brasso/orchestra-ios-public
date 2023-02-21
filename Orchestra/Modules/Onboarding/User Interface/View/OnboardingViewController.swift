//
//  OnboardingViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 05/04/2022.
//
//

import UIKit

class OnboardingViewController: BaseController, OnboardingPageViewControllerDelegate {
    
    // MARK: Properties
    var presenter: OnboardingModuleInterface?
    var onboardingPageViewController: OnboardingPageViewController?
    var openRegister: (() -> Void)?
    var isCancellable = false
    
    // MARK: - Outlets
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.configuration = UIButton.Configuration.plain()
            nextButton.configuration?.titleAlignment = .leading
            nextButton.configuration?.imagePadding = 8
            nextButton.configuration?.imagePlacement = .trailing
            nextButton.setImage(.rightArrow.setTemplate(), for: .normal)
            nextButton.tintColor = .white
            nextButton.setAttributedTitle(LocalizedKey.next.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        }
    }
    
    @IBOutlet var prevButton: UIButton! {
        didSet {
            prevButton.setTitleColor(.white, for: .normal)
            prevButton.configuration = UIButton.Configuration.plain()
            prevButton.configuration?.titleAlignment = .trailing
            prevButton.configuration?.imagePadding = 8
            prevButton.configuration?.imagePlacement = .leading
            prevButton.setImage(.leftArrow.setTemplate(), for: .normal)
            prevButton.tintColor = .white
            prevButton.setAttributedTitle(LocalizedKey.previous.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        }
    }
    
    //MARK: VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Cacher().setValue(true, key: .isAppPreviouslyOpen)
        prevButton.setTitle(LocalizedKey.previous.value, for: .normal)
        prevButton.isHidden = true
        setupNavBar()
    }
    
    private func setupNavBar() {
        if isCancellable {
            let cancelBarButtonItem = UIBarButtonItem(title: LocalizedKey.cancel.value, style: .plain, target: self, action: #selector(cancel))
            navigationItem.rightBarButtonItem = cancelBarButtonItem
        }
    }
    
    //MARK: IBActions
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0...1:
                onboardingPageViewController?.forwardPage()
            case 2:
                 openRegister?()
            default: break
            }
        }
        updateUI()
    }
    
    @IBAction func prevButtonTapped(sender: UIButton) {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 1...2:
                onboardingPageViewController?.rewardPage()
                nextButton.setImage(.rightArrow.setTemplate(), for: .normal)
                nextButton.setAttributedTitle(LocalizedKey.next.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
            default: break
            }
        }
        updateUI()
    }
    
    //MARK: Setup UI
    func updateUI() {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0:
                prevButton.isHidden = true
            case 0...1:
                prevButton.isHidden = false
                nextButton.setTitle(LocalizedKey.next.value, for: .normal)
                nextButton.setAttributedTitle(LocalizedKey.next.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
            case 2:
                nextButton.setImage(.cross, for: .normal)
                nextButton.setAttributedTitle(LocalizedKey.completion.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size14)]), for: .normal)
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    @objc private func cancel() {
        openRegister?()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? OnboardingPageViewController {
            onboardingPageViewController = pageViewController
            onboardingPageViewController?.onboardingDelegate = self
        }
    }
    
}

// MARK: OnboardingViewInterface
extension OnboardingViewController: OnboardingViewInterface {
    
}
