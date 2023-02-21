//
//  UIImageView+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import UIKit.UIImageView
import AlamofireImage
import Kingfisher

extension UIImageView {
    
    func showImage(with url: String?, placeholderImage: UIImage? = GlobalConstants.Image.placeholder, transition: ImageTransition = .noTransition, completion: ((UIImage?) -> ())? = nil) {
        if let url = URL(string: url ?? "") {
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            removeCache(url: url)
            af.setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage, imageTransition: transition, runImageTransitionIfCached: false) { result in
                DispatchQueue.main.async {
                    switch result.result {
                    case .success(_):
                        completion?(result.value)
                    case .failure(_):
                        completion?(nil)
                    }
                }
                print("image result \(result)")
            }
        } else {
            image = placeholderImage
            completion?(nil)
        }
    }
    
    func showImageWithUrl(with url: String?, placeholderImage: UIImage? = GlobalConstants.Image.placeholder, transition: ImageTransition = .noTransition, completion: ((UIImage?, String) -> ())? = nil) {
        if let url = URL(string: url ?? "") {
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            removeCache(url: url)
            af.setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage, imageTransition: transition, runImageTransitionIfCached: false) { result in
                DispatchQueue.main.async {
                    switch result.result {
                    case .success(_):
                        completion?(result.value, url.absoluteString)
                    case .failure(_):
                        completion?(nil, url.absoluteString)
                    }
                }
                print("image result \(result)")
            }
        } else {
            image = placeholderImage
            completion?(nil, "")
        }
    }
    
    func removeCache(url: URL) {
        let request = URLRequest(url: url)
        let imageDownloader = af.imageDownloader
        print("image downloader: \(imageDownloader)")
        if let imageCache = imageDownloader?.imageCache {
            _ = imageCache.removeImage(for: request, withIdentifier: nil)
        }
    }
    
    
    func loadImageTest(url: String, placeholder: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        kf.indicatorType = .activity
        kf.setImage(with: URL(string: url), placeholder: placeholder) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion?(data.image)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(nil)
                }
            }
        }
    }
    
}

class PlayerImage: UIImageView {
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator =  UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(image: UIImage?) {
        super.init(image: image)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareLayout() {
        addSubview(indicator)
        bringSubviewToFront(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    func showImagePlayer(with url: String?, placeholderImage: UIImage? = GlobalConstants.Image.placeholder, transition: ImageTransition = .noTransition, completion: ((UIImage?) -> ())? = nil) {
        if let url = URL(string: url ?? "") {
            indicator.startAnimating()
            af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: transition, runImageTransitionIfCached: false) { result in
                DispatchQueue.main.async { [weak self] in
                    completion?(result.value)
                    self?.indicator.stopAnimating()
                }
            }
        } else {
            image = placeholderImage
        }
    }
    
    func loadImage(url: String, placeholder: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        kf.indicatorType = .activity
        kf.setImage(with: URL(string: url), placeholder: placeholder) { result in
            switch result {
            case .success(let data):
                completion?(data.image)
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    func startIndicator() {
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
    }
    
    
}
