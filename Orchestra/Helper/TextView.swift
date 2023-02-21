//
//  TextView.swift
//  Orchestra
//
//  Created by manjil on 13/04/2022.
//

import UIKit
import Combine

extension UITextView  {
    func textPublisher(_ name: Notification.Name) -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: name, object: self)
            .compactMap { $0.object as? UITextView } // receiving notifications with objects which are instances of UITEXTVIEW
            .map { $0.text ?? "" } // mapping UITextField to extract text
            .eraseToAnyPublisher()
    }
}


class TextView: UITextView {
    
    var bag = Set<AnyCancellable>()
    
    private(set) lazy var placeholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = LocalizedKey.selfIntroduction.value.placeholder
        return label
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        create()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    
    func create() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        addSubview(placeholder)
        
        NSLayoutConstraint.activate([
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            placeholder.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            placeholder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
        ])
        observerEvent()
        font = .notoSansJPRegular(size: .size14)
    }
    
    
    func observerEvent() {
        textPublisher(UITextView.textDidBeginEditingNotification).sink { [weak self] _ in
            guard let self = self else { return }
            self.placeholder.isHidden = true
        }.store(in: &bag)
        
        textPublisher(UITextView.textDidEndEditingNotification).sink { [weak self] string in
            guard let self = self else { return }
            self.placeholder.isHidden = !string.isEmpty
        }.store(in: &bag)
    }
}

