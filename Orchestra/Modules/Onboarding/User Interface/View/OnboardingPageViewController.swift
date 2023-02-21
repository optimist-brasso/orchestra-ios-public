//
//  OnboardingPageViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 06/04/2022.
//

import UIKit

protocol OnboardingPageViewControllerDelegate: AnyObject {
    
    func didUpdatePageIndex(currentIndex: Int)
    
}

class OnboardingPageViewController: UIPageViewController {

    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
//        removeSwipeGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        removeSwipeGesture()
    }
    
    // MARK: Other functions
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= GlobalConstants.Onboarding.sectionHeading.count {
            return nil
        }
        // Create a new view controller and pass suitable data
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController {
            pageContentViewController.imageFile = GlobalConstants.Onboarding.images[index]
            pageContentViewController.heading = GlobalConstants.Onboarding.sectionHeading[index]
            pageContentViewController.subHeading1 = GlobalConstants.Onboarding.sectionSubHeading1[index]
            pageContentViewController.subHeading2 =  GlobalConstants.Onboarding.sectionSubHeading2[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    func removeSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func rewardPage() {
        currentIndex = currentIndex - 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
}

//MARK: UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
}

//MARK: UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentIndex = contentViewController.index
                onboardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    
}
