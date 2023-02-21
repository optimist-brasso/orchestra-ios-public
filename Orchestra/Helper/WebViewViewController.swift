//
//  WebViewViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/08/2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    // MARK: Properties
    private var timer: Timer?
    private var finished = false
    let webTitle: String?
    let url: String?
    
    // MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleContainerView,
                                                       webView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 47).isActive = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label,
                                                       closeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = webTitle
        label.textColor = UIColor(hexString: "#0D6483")
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cross")?.withTintColor(UIColor(hexString: "#0D6483")), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: .zero)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(hexString: "#0D6483")
        progressView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return progressView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D8D8D8")
        return view
    }()
    
    //MARK: Initializers
    init(title: String?, url: String?) {
        self.webTitle = title
        self.url = url
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavBar()
    }
    
    // MARK: Other Functions
    private func setup() {
        prepareLayout()
        if let url = URL(string: url ?? "") {
            let request = URLRequest(url: url)
            showLoading()
            webView.load(request)
        }
    }
    
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        //navigationItem.leadingTitle = "My Page"
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonTapped))
        
        navigationItem.leftBarButtonItems = [backButtonItem]

    }
    
    private func prepareLayout() {
        view.addSubview(stackView)
        stackView.fillSuperView()
        
        titleContainerView.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
            titleStackView.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            titleStackView.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor)
        ])
        
        titleContainerView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            seperatorView.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor)
        ])
        
        titleContainerView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            progressView.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: seperatorView.topAnchor)
        ])
    }
    
    private func startLoading() {
        progressView.progress = .zero
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    private func finishLoading() {
        finished = true
    }
    
    @objc private func timerCallback() {
        if finished {
            if progressView.progress >= 1 {
                progressView.isHidden = true
                timer?.invalidate()
            } else {
                progressView.progress = 1
            }
        } else {
            progressView.progress += 0.05
            if progressView.progress >= 0.80 {
                progressView.progress = 0.80
            }
        }
    }
    
    @objc private func buttonTapped() {
        dismiss(animated: true)
    }
}

//MARK: WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        startLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
        finishLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        finishLoading()
    }
    
}

