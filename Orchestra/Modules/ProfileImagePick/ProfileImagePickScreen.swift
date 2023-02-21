//
//  ProfileImagePickScreen.swift
//  Orchestra
//
//  Created by manjil on 10/04/2022.
//

import UIKit
import Alamofire

class ProfileImagePickScreen: BaseScreen {
    
    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var gestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var boarderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        return view
    }()
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "写真を選択してください"
        label.textColor = .black
        label.font = .notoSansJPLight(size: .size12)
        label.accessibilityIdentifier = "title"
        return label
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //    image.layer.cornerRadius = 84
        //        image.layer.borderColor = UIColor.lightGray.cgColor
        //        image.layer.borderWidth = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 23
        view.distribution = .fillEqually
        return view
    }()
    
    private(set) lazy var libraryButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.imagePlaceholder, for: .normal)
        return button
    }()
    
    private(set) lazy var cameraButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.camera, for: .normal)
        return button
    }()
    
    private(set) lazy var saveButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.appButtonType = .auth
        button.backgroundColor = .blackBackground
        button.setTitle(LocalizedKey.toSave.value, for: .normal)
        return button
    }()
    
    private var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        shapeLayer.lineDashPattern = [10, 10]
        return shapeLayer
    }()
    
    override func create() {
        addSubview(gestureView)
        addSubview(view)
        backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(boarderView)
        boarderView.addSubview(imageView)
        boarderView.addSubview(title)
        view.addSubview(stackView)
        stackView.addArrangedSubview(libraryButton)
        stackView.addArrangedSubview(cameraButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            gestureView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gestureView.topAnchor.constraint(equalTo: topAnchor),
            gestureView.centerXAnchor.constraint(equalTo: centerXAnchor),
            gestureView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            boarderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boarderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            boarderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boarderView.heightAnchor.constraint(equalToConstant: 230),
            
            imageView.leadingAnchor.constraint(equalTo: boarderView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: boarderView.topAnchor),
            imageView.centerYAnchor.constraint(equalTo: boarderView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: boarderView.centerXAnchor),
            
            title.centerYAnchor.constraint(equalTo: boarderView.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: boarderView.centerXAnchor),
            //imageView.heightAnchor.constraint(equalToConstant: 168),
            // imageView.widthAnchor.constraint(equalToConstant: 168),
            
            stackView.topAnchor.constraint(equalTo: boarderView.bottomAnchor, constant: 18),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 26),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 28),
            
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 18),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 135),
            saveButton.heightAnchor.constraint(equalToConstant: 28),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
        ])
        
        imageView.layer.addSublayer(shapeLayer)
        //updatePath()
    }
    
    //    override func draw(_ rect: CGRect) {
    //        updatePath()
    //    }
    //    func updatePath() {
    //        let rect = imageView.bounds//.insetBy(dx: shapeLayer.lineWidth / 2, dy: shapeLayer.lineWidth / 2)
    //            let radius = min(rect.width, rect.height) / 2
    //            let center = CGPoint(x: rect.midX, y: rect.midY)
    //            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    //            shapeLayer.path = path.cgPath
    //        }
}


class ProfileImagePickController: BaseController {
    
    private var screen: ProfileImagePickScreen  {
        baseScreen as! ProfileImagePickScreen
    }
    
    private var presenter: BasePresenter  {
        basePresenter
    }
    
    let cameraHandler =  CameraHandler()
    var canUpload = false
    var imagePickedBlock: ((UIImage) -> Void)?
    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        screen.gestureView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Other functions
    override func observerScreen() {
        screen.cameraButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.cameraHandler.showActionSheet(vc: self, type: .camera)
        }.store(in: &presenter.bag)
        
        screen.libraryButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.cameraHandler.showActionSheet(vc: self, type: .photo)
        }.store(in: &presenter.bag)
        
        screen.saveButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).sink { [weak self] _ in
            guard let self = self else { return }
            if let  image =  self.screen.imageView.image  {
               if self.canUpload {
                    self.upload(image: image)
                } else {
                    self.imagePickedBlock?(image)
                    self.dismiss(animated: true)
                }
            } else {
                self.alert(title: "", msg: LocalizedKey.selectProfileImage.value, actions: [AlertConstant.ok])
            }
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        cameraHandler.imagePickedBlock = { [weak self] image in
            guard let self = self else { return }
            self.screen.imageView.image = image
            self.screen.title.isHidden = true
        }
    }
    
    private func upload(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1)
        else {
            alert(title: "", msg: LocalizedKey.selectProfileImage.value, actions: [AlertConstant.ok])
            return
        }
        let value = DatabaseHandler.shared.fetch(object: ConfigData.self)?.first?.profileImageSize ?? "2048"
        let neededSize = (Int(value) ?? .zero) * 1024
        if data.count > neededSize {
            alert(title: "", msg: LocalizedKey.errorImageSize("\(value)").value, actions: [AlertConstant.ok])
            return
        }
        upload(image: data)
    }
    
    private func upload(image: Data) {
        if NetworkReachabilityManager()?.isReachable == true {
            showLoading()
            let urlSession = URLSession.shared
            let endPoint = EK_EndPoint(path: "user/profile-image", method: .put)
            let request = endPoint.request()
            var files = [URLSession.File]()
            files.append(URLSession.File(name: "profile_image", fileName:  "profile_image", data: image, contentType: "image/jpeg"))
            urlSession.fileUpload(request: request, params: [:], files: files) {  [weak self] (result: Result<ResponseMessage, Error>) in
                guard let self = self  else { return}
                self.hideLoading()
                switch result {
                case .success:
                    if let  image =  self.screen.imageView.image  {
                        self.imagePickedBlock?(image)
                        NotificationCenter.default.post(name: Notification.update, object: nil)
                    }
                    self.dismiss(animated: true)
                case .failure(let error):
                    self.alert(title: "", msg: error.localizedDescription, actions: [AlertConstant.ok])
                }
            }
        } else {
            alert(title: "", msg: GlobalConstants.Error.noInternet.localizedDescription, actions: [AlertConstant.ok])
        }
    }
    
    @objc private func dismissView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
}

