//
//  AlertActionable.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit

/// The alert protocol
public protocol AlertActionable {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    var tag: Int { get }
}
 
