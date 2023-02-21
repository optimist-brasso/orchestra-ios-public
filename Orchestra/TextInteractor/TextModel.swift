//
//  TextModel.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine

public enum AppError: Error, LocalizedError {
    case requiredField(String)
    case custom (String)
    
    
    public var localizedDescription: String {
        switch self {
        case .requiredField(let error): return error
        case .custom(let error): return  error
        }
    }
}

public protocol  Plainable {
    var name: String { get }
    func error(isEmpty: Bool) -> String 
}
public protocol Fieldable {
    var   pattern: String { get }
}

public protocol TextFieldInteractable {
    func isValid(value: String?) -> AppError?
    var pattern: PatternIdentifiable {get set}
}

enum PlainFieldType: Plainable {
    case none
    case email
    case otp
    case newPassword
    case oldPassword
    case password
    case fullName
    case nickName
    case otherGender
    case instrument
    case postalCode
    case confirmPassword
    case dob
    case occupation
    case selfIntroduction
    case phone
    
    
    var name: String {
        switch self {
        case .none:
            return ""
        case .email:
            return LocalizedKey.emailAddress.value
        case .otp:
            return  LocalizedKey.pleaseEnterYourOTP.value
        case .password:
            return  LocalizedKey.registerPassword.value
        case .fullName:
            return  LocalizedKey.fullName.value
        case .confirmPassword:
            return  LocalizedKey.newPasswordConfirm.value
        case .dob:
            return LocalizedKey.age.value
        case .phone:
            return "phone"
        case .nickName:
            return  LocalizedKey.nickname.value
        case .instrument:
            return LocalizedKey.musicalInstruments.value
        case .postalCode:
            return  LocalizedKey.postalCode.value
        case .occupation:
            return  LocalizedKey.occupation.value
        case .selfIntroduction:
            return  LocalizedKey.selfIntroduction.value
        case .otherGender:
            return LocalizedKey.addGender.value
        case .newPassword:
            return LocalizedKey.newPassword.value
        case .oldPassword:
            return LocalizedKey.oldPassword.value
        }
    }
    
    func error(isEmpty: Bool) -> String {
        switch self {
        case .none:
            return ""
        case .email:
            return isEmpty ? LocalizedKey.emailRequired.value : LocalizedKey.emailInValid.value
        case .otp:
            return LocalizedKey.pleaseEnterYourOTP.value
        case .password:
            return  isEmpty ? LocalizedKey.passwordRequired.value :  LocalizedKey.passwordNote.value
        case .fullName:
            return LocalizedKey.fullnameRequired.value
        case .nickName:
            return LocalizedKey.nicknameRequired.value
        case .otherGender:
            return ""
        case .instrument:
            return LocalizedKey.instrumentRequired.value
        case .postalCode:
            return LocalizedKey.postalCodeRequired.value
        case .confirmPassword:
            return LocalizedKey.confirmPasswordIsRequired.value
        case .dob:
            return LocalizedKey.dobRequired.value
        case .occupation:
            return LocalizedKey.professionRequired.value
        case .selfIntroduction:
            return ""
        case .phone:
            return ""
        case .newPassword:
            return  isEmpty ? LocalizedKey.newPasswordIsRequired.value : LocalizedKey.passwordNote.value
        case .oldPassword:
            return LocalizedKey.oldPasswordIsRequired.value
        }
    }
}

class TextModel: ObservableObject {
    
    var bag = Set<AnyCancellable>()
    
    @Published var value: String = ""
    @Published var error: AppError? = nil
    
    let dataType: Plainable
    let interactor: TextFieldInteractable
    init(dataType: PlainFieldType, interactor: TextFieldInteractable = TextInteractor(type: PlainFieldType.none, pattern: Pattern.none, optional: false) ) {
        self.dataType = dataType
        self.interactor  = interactor
        
        $value.sink { [weak self] value in
            guard let self = self else { return }
            self.isValid(value: value)
        }.store(in: &bag)
        
    }
    
    func isValid(value: String) {
        error = interactor.isValid(value: value)
    }
}





