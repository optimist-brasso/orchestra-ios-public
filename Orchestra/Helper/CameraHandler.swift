//
//  CameraHandler.swift
//  Orchestra
//
//  Created by manjil on 07/04/2022.
//

import UIKit

enum SourceType {
    case camera
    case photo
    case none
}

class CameraHandler: NSObject {
    static let shared = CameraHandler()
    
    fileprivate weak var  currentVC: BaseController!
    
    private lazy var imagePickerController: UIImagePickerController   =  {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.navigationBar.isTranslucent = false
        pickerController.delegate = self;
        return pickerController
    }()
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    private  func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            currentVC.present(imagePickerController, animated: true, completion: nil)
        } else {
            currentVC.alert(title: "", msg: "Device doesn't support camera feature.", actions: [AlertConstant.ok])
        }
    }
    
    private func photoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            currentVC.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: BaseController, type: SourceType) {
        
        currentVC = vc
        if case .camera = type {
            camera()
            return
        }
        if case .photo = type {
            photoLibrary()
            return
        }
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(actionSheet, animated: true, completion: nil)
        
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imagePickedBlock?(selectedImage)
        } else if let seletedImage = info[.originalImage] as? UIImage {
            imagePickedBlock?(seletedImage)
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
}
