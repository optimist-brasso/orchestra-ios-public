//
//  StoryboardIdentifiable.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit

//// 1. make storyboard conforms to this for identification
 protocol StoryboardIdentifiable {
    var identifier: String { get }
}

//// 2. protocol to conforms to the storyboard identifier
protocol StoryboardInitializable {
     static var storyboardIdentifier: String { get }
}

//// 3. create extension and implement the initialization
 extension StoryboardInitializable where Self: BaseController {

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

     static func initialize(from storyboard: StoryboardIdentifiable, presenter: BasePresenter) -> Self {
        let storyboard = UIStoryboard(name: storyboard.identifier, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
         controller.setViewModel(presenter: presenter)
        return controller
    }
}

