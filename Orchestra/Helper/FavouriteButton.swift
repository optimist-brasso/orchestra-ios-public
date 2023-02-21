//
//  FavouriteButton.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/04/2022.
//

import UIKit.UIButton
import Alamofire

class FavouriteButton: UIButton {
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Other functions
    private func setup() {
        setImage(GlobalConstants.Image.TabBar.favourite, for: .normal)
        setImage(GlobalConstants.Image.favourite, for: .selected)
        addTarget(self, action: #selector(buttonTappd(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTappd(_ sender: UIButton) {
        if NetworkReachabilityManager()?.isReachable == true {
            if isLoggedIn {
                sender.isSelected.toggle()
            }
        }
    }
    
}

//MARK: LoggedInProtocol
extension FavouriteButton: LoggedInProtocol {}
