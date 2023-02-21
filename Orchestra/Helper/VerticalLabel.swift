//
//  VerticalLabel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//

import UIKit.UILabel

class VerticalLabel: UILabel {

    override func draw(_ rect: CGRect) {
        guard let text = self.text else {
            return
        }
        if let context = UIGraphicsGetCurrentContext() {
            let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            context.concatenate(transform)
//            context.translateBy(x: .zero, y: -rect.size.height)
            var newRect = rect.applying(transform)
            newRect.origin = .zero
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.lineBreakMode = lineBreakMode
            textStyle.alignment = textAlignment
            let attributeDict: [NSAttributedString.Key: Any] = [
                .font: font ?? .systemFont(ofSize: 12),
                .foregroundColor: textColor ?? .black,
                .paragraphStyle: textStyle]
            let nsStr = text as NSString
            nsStr.draw(in: newRect, withAttributes: attributeDict)
        }
    }

}

@IBDesignable
public class ExtendedLabel: UILabel {
  
  var textInsets = UIEdgeInsets.zero {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override public func drawText(in rect: CGRect) {
    self.setNeedsLayout()
    super.drawText(in: rect.inset(by: self.textInsets))
  }
}

extension ExtendedLabel {
  
  @IBInspectable
  var rotation: Int {
    get {
      return 0
    } set {
      self.rotate(degrees: newValue)
    }
  }
  
  private func rotate(degrees: Int) {
    
    rotate(radians: CGFloat.pi * CGFloat(degrees) / 180.0)
  }
  
  private func rotate(radians: CGFloat) {
    
    self.transform = CGAffineTransform(rotationAngle: radians)
  }
  
  @IBInspectable
  var leftTextInset: CGFloat {
    set { self.textInsets.left = newValue }
    get { return self.textInsets.left }
  }
  
  @IBInspectable
  var rightTextInset: CGFloat {
    set { self.textInsets.right = newValue }
    get { return self.textInsets.right }
  }
  
  @IBInspectable
  var topTextInset: CGFloat {
    set { self.textInsets.top = newValue }
    get { return self.textInsets.top }
  }
  
  @IBInspectable
  var bottomTextInset: CGFloat {
    set { self.textInsets.bottom = newValue }
    get { return self.textInsets.bottom }
  }
}
