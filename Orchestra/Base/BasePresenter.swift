//
//  BasePresenter.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import Foundation
import Combine

class  BasePresenter {
    /// The subcription cleanup bag
    public var bag: Set<AnyCancellable>

    /// Routes trigger
    public let trigger: PassthroughSubject<AppRoutable, Never>
    
    /// The initializer
    public init() {
        self.bag = Set<AnyCancellable>()
        self.trigger = PassthroughSubject<AppRoutable, Never>()
    }

    /// Deint call check
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
}
