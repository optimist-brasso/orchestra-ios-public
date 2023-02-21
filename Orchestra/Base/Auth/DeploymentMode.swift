//
//  DeploymentMode.swift
//  
//
//  Created by Mukesh Shakya on 06/01/2022.
//

import Foundation

public struct DeploymentMode: OptionSet {
    
    public typealias RawValue = Int
    
    public static func ==(lhs: DeploymentMode, rhs: DeploymentMode) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public var rawValue: DeploymentMode.RawValue
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let dev: DeploymentMode = DeploymentMode(rawValue: 0)
    public static let qa: DeploymentMode = DeploymentMode(rawValue: 1)
    public static let uat: DeploymentMode = DeploymentMode(rawValue: 2)
    public static let live: DeploymentMode = DeploymentMode(rawValue: 3)
    
}
