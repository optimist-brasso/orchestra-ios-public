//
//  SplashViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import UIKit
import SwiftyGif

class SplashViewController: BaseController {
    
    // MARK: Properties
    var presenter: SplashModuleInterface?
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGif()
    }
    
    private func setupGif() {
        imageView.delegate = self
        do { let gif = try UIImage(gifName: "BRASSO_SPLASH_0623_fin.gif")
            imageView.setGifImage(gif, loopCount: 1)
        } catch {
            print(error)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

extension SplashViewController: SwiftyGifDelegate {
    
    func gifDidStop(sender: UIImageView) {
        presenter?.requestAppInfo()
    }
    
}

// MARK: SplashViewInterface
extension SplashViewController: SplashViewInterface {
    
    func obtainedSuccess() {
       // NotificationCenter.default.post(name: Notification.splashComplete, object: nil)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func show(_ error: Error) {
        alert(msg: error.localizedDescription) { _ in
                self.presenter?.requestAppInfo()
        }
    }
    
}
