//
//  BaseViewInterface.swift
//  
//
//  Created by Mukesh Shakya on 05/01/2022.
//

import UIKit.UIAlertController

public protocol BaseViewInterface {
    
    func showLoading()
    func showLoading(with message: String)
    func hideLoading()
    func alert(message: String?)
    func alert(message: String?, title: String?, okAction: (()->())?)
    func alertWithOkCancel(message: String?,
                           title: String?,
                           style: UIAlertController.Style?,
                           okTitle: String?,
                           okStyle: UIAlertAction.Style,
                           cancelTitle: String?,
                           cancelStyle: UIAlertAction.Style,
                           okAction: (()->())?,
                           cancelAction: (()->())?)
    
}
