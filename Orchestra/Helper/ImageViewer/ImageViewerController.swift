//
//  ImageViewerController.swift
//  Chattery
//
//  Created by Bibek Sharma Timalsina on 6/14/18.
//  Copyright © 2018 Orchestra. All rights reserved.
//

import UIKit
import AVFoundation

class ImageViewerController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var image: UIImage?
    private var imageURL: URL?
    private var placeHolder: UIImage?
    private var info: String?
    private var name: String!
//    private let fileManger = ManageFileService.shared

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    init(image: UIImage, name: String, info: String?) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        self.image = image
        self.info = info
        self.name = name
        setup()
    }

    init(imageURL: URL, placeHolder: UIImage, name: String, info: String?) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        self.imageURL = imageURL
        self.placeHolder = placeHolder
        self.info = info
        self.name = name
        setup()
    }

    func setup() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupGestureRecognizers()
        setupImage()
        let color = UIColor.appGreen
        closeButton.tintColor = .white
        shareButton.setTitleColor(color, for: .normal)
        shareButton.isHidden = true
        progressView.progressTintColor = color
    }
    
}

//MARK: UIScrollViewDelegate
extension ImageViewerController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
        let imageViewSize = ImageViewerUtilities.aspectFitRect(forSize: image.size, insideRect: imageView.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideHeaderAndFooter()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideHeaderAndFooter()
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        hideHeaderAndFooter()
    }
    
}

//MARK: UIGestureRecognizerDelegate
extension ImageViewerController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
    
}

//MARK: ImageViewerController
private extension ImageViewerController {
    
    func setupImage() {
        infoLabel.numberOfLines = .zero
        infoLabel.text = "\(name!) (\(info ?? ""))"
        infoLabel.isHidden = info == nil
        progressView.isHidden = true
        
        if let imageURL = imageURL {
            imageView.af.setImage(withURL: imageURL,  completion: { [weak self] imageResponse in
                switch imageResponse.result {
                case .success:
                    self?.image = imageResponse.value
                    self?.imageView.contentMode = .scaleAspectFit
                default: break
                }
            })
        } else {
            imageView.image = image
        }
    }
    
    func enableActions() {
        shareButton.isEnabled = true
    }
    
    func disableActions() {
        shareButton.isEnabled = false
    }
    
    func setupScrollView() {
//        scrollView.decelerationRate = UIScrollView.DecelerationRate.hash
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.delegate = self
    }
    
    func setupGestureRecognizers() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.addTarget(self, action: #selector(self.imageViewDoubleTapped))
        imageView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(self.imageViewTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func shareButtonPressed(_ button: UIButton) {
        guard let _ = image, let _ = name else {return}
        savedLabel.isHidden = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.savedLabel.isHidden = false
        }
        let saveToGalleryAction = UIAlertAction(title: "Save to gallery", style: .default) { (_) in
            self.saveImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(saveToGalleryAction)
        alert.addAction(cancelAction)
        present(alert, asActionsheetInSourceView: button)
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(message: error.localizedDescription)
        } else {
            savedLabel.isHidden = false
        }
    }
    
    @objc func imageViewTapped() {
        if headerView.isHidden {
            showHeaderAndFooter()
        } else {
            hideHeaderAndFooter()
        }
    }
    
    func showHeaderAndFooter() {
        headerView.isHidden = false
        footerView.isHidden = false
        UIView.animate(withDuration: 0.22, animations: {
            self.headerView.alpha = 1
            self.footerView.alpha = 1
        })
    }
    
    func hideHeaderAndFooter() {
        UIView.animate(withDuration: 0.22, animations: {
            self.headerView.alpha = .zero
            self.footerView.alpha = .zero
        }, completion: { _ in
            self.headerView.isHidden = true
            self.footerView.isHidden = true
        })
    }
    
    @objc func imageViewDoubleTapped() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
}

//MARK: UIViewController extension
extension UIViewController {
    
    func present(_ alert: UIAlertController, asActionsheetInSourceView sourceView: Any) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.modalPresentationStyle = .popover
            if let presenter = alert.popoverPresentationController {
                if sourceView is UIBarButtonItem {
                    presenter.barButtonItem = sourceView as? UIBarButtonItem
                } else if sourceView is UIView {
                    let view = sourceView as! UIView
                    presenter.sourceView = view
                    presenter.sourceRect = view.bounds
                }
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}

