//
//  PaddingLabel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class PaddingLabel: UILabel {

    var inset: UIEdgeInsets = .zero
    
    init(_ inset: UIEdgeInsets) {
        self.inset = inset
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + inset.left + inset.right,
                      height: size.height + inset.top + inset.bottom)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (inset.left + inset.right)
        }
    }
    
}
