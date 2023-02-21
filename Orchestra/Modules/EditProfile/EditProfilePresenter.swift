//
//  EditProfilePresenter.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import Foundation
import Combine
import Alamofire

enum GenderType: Int {
    case male
    case female
    case addOther
    
    var value: String {
        switch self {
        case .male:
            return LocalizedKey.male.value
        case .female:
            return LocalizedKey.female.value
        case .addOther:
            return ""
        }
    }
}

class EditProfilePresenter: BasePresenter, LoginApi, LoggedInProtocol {
    
    let fullName = TextModel(dataType: .fullName, interactor: TextInteractor(type: PlainFieldType.fullName, pattern: Pattern.none))
    let otherGender = TextModel(dataType: .fullName, interactor: TextInteractor(type: PlainFieldType.otherGender, pattern: Pattern.none, optional: true))
    let nickName = TextModel(dataType: .nickName, interactor: TextInteractor(type: PlainFieldType.nickName, pattern: Pattern.none))
    let instrument = TextModel(dataType: .instrument, interactor: TextInteractor(type: PlainFieldType.instrument, pattern: Pattern.none))
    let postalcode = TextModel(dataType: .postalCode, interactor: TextInteractor(type: PlainFieldType.postalCode, pattern: Pattern.none))
    let age = TextModel(dataType: .dob, interactor: TextInteractor(type: PlainFieldType.dob, pattern: Pattern.none))
    let occupation = TextModel(dataType: .occupation, interactor: TextInteractor(type: PlainFieldType.occupation, pattern: Pattern.none))
    let selfIntroduction = TextModel(dataType: .selfIntroduction, interactor: TextInteractor(type: PlainFieldType.selfIntroduction, pattern: Pattern.none, optional: true))
    
    var error: [AppError] = []
    var selected = GenderType.male
    var selectedOccupation = 0
    
    var isAuthflow: Bool {
        return profile == nil
    }
    
    let urlSession = URLSession.shared
    let response = PassthroughSubject<(String, Bool), Never>()
    let imageDeleteResponse = PassthroughSubject<Void, Never>()
    
    var pro = [Profession]()
    var configApp: ConfigData?
    
    let manager: UserManager
    var profile: ProfileStructure?
    var email: String?
    var password: String?
    
    init(profile: ProfileStructure?) {
        self.profile  = profile
        self.manager = UserManager()
        super.init()
        observeEvent()
        getData()
        setData()
    }
    
    func observeEvent() {
        let publisher1 = Publishers.CombineLatest4(fullName.$error, nickName.$error, instrument.$error, postalcode.$error)
        let publisher2 = Publishers.CombineLatest3(age.$error, occupation.$error, selfIntroduction.$error)
        Publishers.CombineLatest(publisher1, publisher2).map { (fields1, fields2 ) -> [AppError]  in
            let (fullNameError, nickError, instrumentError, postCodeError ) = fields1
            let ( ageError, occupationError, selfIntroductionError) = fields2
            let result = [
                fullNameError,
                nickError,
                instrumentError,
                postCodeError,
                ageError,
                occupationError,
                selfIntroductionError
            ]
            return result.compactMap{ $0 }
        }.eraseToAnyPublisher().sink { [weak self] result in
            guard let self = self else { return }
            self.error = result
        }.store(in: &bag)
        NotificationCenter.default.addObserver(self, selector: #selector(getProfile(_:)), name: Notification.update, object: nil)
    }
    
    var paramaters: [String: Any] {
        var json: [String: Any] = [:]
        if isAuthflow {
            if isLoggedIn && isSocialLogin, !(email?.isEmpty ?? true) {
                json["email"] = email
            } else if !isSocialLogin {
                json["email"] = email ?? Cacher().get(String.self, forKey: .email) ?? ""
            }
        }
        json["username"] = nickName.value.trim
        json["gender"] = selected.value
        json["dob"] = age.value
        json["short_description"] = selfIntroduction.value.trim
        json["professional_id"] = selectedOccupation
        json["postal_code"] = postalcode.value.trim
        json["name"] = fullName.value.trim
        json["music_instrument"] = instrument.value.trim
        if case .addOther = selected {
            json["gender"] = otherGender.value.trim
        }
        return json
    }
    
//    func  updateParam() -> [String: Any] {
//        var json: [String: Any] = [:]
//        json["username"] = nickName.value.trim
//        json["gender"] = selected.value
//        json["dob"] = age.value
//        json["short_description"] = selfIntroduction.value.trim
//        json["professional_id"] = selectedOccupation
//        json["postal_code"] = postalcode.value.trim
//        json["name"] = fullName.value.trim
//        json["music_instrument"] = instrument.value.trim
//        if case .addOther = selected {
//            json["gender"] = otherGender.value.trim
//        }
//        return json
//    }
    
    func upload(image: Data?) {
        if NetworkReachabilityManager()?.isReachable == true {
            let urlSession = URLSession.shared
            let endPoint = EK_EndPoint(path: "auth/register", method: .post)
            let request = endPoint.request()
            var files = [URLSession.File]()
            if let image = image {
                files.append(URLSession.File(name: "profile_image", fileName:  "profile_image", data: image, contentType: "image/jpeg"))
            }
            urlSession.fileUpload(request: request, params: paramaters, files: files) {  [weak self] (result: Result<ResponseMessage, Error>) in
                guard let self = self  else { return}
                switch result {
                case .success((let model)):
                    self.response.send((model.detail ?? "", true))
                case .failure(let error):
                    self.response.send((error.localizedDescription, false))
                }
            }
        } else {
            response.send((GlobalConstants.Error.noInternet.localizedDescription, false))
        }
    }
    
    func getData() {
        if  let data =  DatabaseHandler.shared.fetch(object: Profession.self) {
            pro = Array(data)
        }
        if let data = DatabaseHandler.shared.fetch(object: ConfigData.self)?.first {
            configApp = data
        }
    }
    
    
    //    func upload(image: Data?) {
    //        guard let image = image else {
    //            return
    //        }
    //
    //        let file = File(data: image, key: "profile_image", name: "profile_image", mimeType: "jpeg")
    //
    //        manager.requestUpload(type: SendToken.self, router: AuthRouter.register(file: file, parameters: param())).sink { [weak self] result in
    //            if let object = result.object?.data {
    //                self?.response.send((object.detail, result.success))
    //                print("MESSARGE_EDIT_PROFIE\(object.detail)")
    //            } else {
    //                self?.response.send((result.error.description, result.success))
    //                print("ERROR_EDIT_PROFIE\(result.error.description)")
    //            }
    //        }.store(in: &bag)
    //    }
    
    func setData() {
        guard let profile = profile else {
            return
        }
        fullName.value = profile.name ?? ""
        nickName.value   = profile.nickname ?? ""
        instrument.value = profile.musicalInstrument ?? ""
        postalcode.value = profile.postalCode ?? ""
        age.value = profile.age ?? ""
        occupation.value = profile.profession ?? ""
        selfIntroduction.value = profile.selfIntroduction
        
        let gender = profile.gender ?? ""
        switch  gender {
        case GenderType.female.value:
            selected = .female
            otherGender.value = ""
        case GenderType.male.value:
            selected = .male
            otherGender.value = ""
        default :
            selected = .addOther
            otherGender.value = gender
        }
        if let index = pro.firstIndex(where: { $0.title == occupation.value }) {
            selectedOccupation = pro[index].id
        }
    }
    
    func deleteProfileImage() {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "user/profile-image", method: .delete)
            urlSession.dataTask(request: endPoint.request()) { [weak self] (result: Result<(ResponseMessage, _), Error>) in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.imageDeleteResponse.send()
                    NotificationCenter.default.post(name: Notification.update, object: nil)
                case .failure(let error):
                    self.response.send((error.localizedDescription, false))
                }
            }
        } else {
            response.send((GlobalConstants.Error.noInternet.localizedDescription, false))
        }
    }
    
    func updateProfile() {
        //        if let profile = profile, profile.image?.isEmpty ?? true {
        //            response.send((LocalizedKey.selectImage.value, false))
        //            return
        //        }
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "user/profile", method: .put)
            let request = endPoint.request(body: paramaters)
            URLSession.shared.dataTask(request: request) {  [weak self] (result: Result<(Profile, Pagination?), Error>) in
                guard let self = self  else { return }
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.update, object: nil)
                    self.response.send((LocalizedKey.updateProfileSuccessful.value, true))
                case .failure(let error):
                    self.response.send((error.localizedDescription, false))
                }
            }
        } else {
            response.send((GlobalConstants.Error.noInternet.localizedDescription, false))
        }
    }
    
    func login() {
        if let email = email ?? Cacher().get(String.self, forKey: .email), let password = password {
            login(email: email, password: password) { [weak self] result in
                switch result {
                case .success(_):
                    self?.trigger.send(.splash)
                case .failure(let error):
                    self?.response.send((error.localizedDescription, false))
                }
            }
        } else {
            trigger.send(.splash)
//            trigger.send(.homePage)
        }
    }
    
    @objc private func getProfile(_ notification: Notification) {
        if let profile = notification.object as? ProfileStructure {
            self.profile = profile
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



