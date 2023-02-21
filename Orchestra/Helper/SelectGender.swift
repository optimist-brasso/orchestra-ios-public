//
//  SelectGender.swift
//  Orchestra
//
//  Created by manjil on 05/04/2022.
//

import UIKit
class SelectGender: UIControl {
    
    private(set) lazy var genderStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private(set) lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "gender "
        view.font = .notoSansJPRegular(size: .size14)
        return view
    }()
    private(set) lazy var radioView: RadioView  = {
        let view = RadioView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    //By default it is true
    var useHapticFeedback: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
       // isUserInteractionEnabled = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func create() {
        addSubview(genderStack)
        genderStack.addArrangedSubview(radioView)
        genderStack.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            genderStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            genderStack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            genderStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            genderStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            radioView.heightAnchor.constraint(equalToConstant: 20),
            radioView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }
    
    //On touches ended,
    //change the selected state of the component, and changing *isChecked* property, draw methos will be called
    //So components appearance will be changed accordingly
    //Hence the state change occures here, we also sent notification for value changed event for this component.
    //After usage of feedback generator object, we make it nill.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        super.touchesEnded(touches, with: event)
        
        radioView.isChecked.toggle()
        self.sendActions(for: .touchUpInside)
        if useHapticFeedback {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            radioView.isChecked = isSelected
        }
    }
}


class RadioView: UIView {
    
    var uncheckedBorderColor: UIColor = .gray
    
    var checkedBorderColor: UIColor = .gray
    
    
    var checkmarkColor: UIColor = .black
    
    var borderWidth: CGFloat = 1.75
    
    var checkmarkSize: CGFloat = 0.5
    
    var checkboxBackgroundColor: UIColor! = .white
    
    var isChecked: Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //Draw the outlined component
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        let  shapePath = UIBezierPath.init(ovalIn: newRect)
        
        
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        //When it is selected, depends on the style
        //By using helper methods, draw the inner part of the component UI.
        if isChecked {
            self.drawCircle(frame: newRect)
        }
    }
    
    //Draws circle inside the component
    func drawCircle(frame: CGRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkmarkColor.setFill()
        ovalPath.fill()
    }
    
}
