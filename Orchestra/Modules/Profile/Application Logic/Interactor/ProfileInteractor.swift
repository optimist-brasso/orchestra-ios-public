//
//  ProfileInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class ProfileInteractor {
    
	// MARK: Properties
    var profile: ProfileStructure?
    weak var output: ProfileInteractorOutput?
    private let service: ProfileServiceType
    
    // MARK: Initialization
    init(service: ProfileServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(update(_:)), name: Notification.update, object: nil)
//        NotificationCenter.default.addObserver(forName: Notification.update, object: nil, queue: nil) { [weak self] _ in
//            self?.getData()
//        }
    }

    // MARK: Converting entities
    private func convert(_ model: Profile) -> ProfileStructure {
        return ProfileStructure(name: model.name,
                                gender: model.gender,
                                nickname: model.username,
                                musicalInstrument: model.musicalInstrument,
                                postalCode: model.postalCode,
                                age: model.dob == nil ? nil : DateFormatter.toString(date: DateFormatter.toDate(dateString: model.dob ?? "") ?? Date(), format: "yyyy-MM-dd"),
                                email: model.email,
                                profession: model.profession,
                                image: model.image,
                                selfIntroduction: model.selfIntroduction ?? "")
    }
    
    //MARK: Other functions
    @objc private func update(_ notification: Notification) {
        if notification.object == nil {
            getData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Profile interactor input interface
extension ProfileInteractor: ProfileInteractorInput {
    
    func getData() {
        service.fetchProfile { [weak self] result in
            switch result {
            case .success(let model):
                if let structure = self?.convert(model) {
                    self?.profile = structure
                    NotificationCenter.default.post(name: Notification.update, object: structure, userInfo: nil)
                    self?.output?.obtained(structure)
                }
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
}
