//
//  Array+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import Foundation

extension Array {
    
    func element(at index: Int) -> Element? {
        if index >= .zero && index < count {
            return self[index]
        }
        return nil
    }
}
