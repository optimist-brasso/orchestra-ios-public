//
//  ProfilePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class ProfilePresenter {
    
	// MARK: Properties
    weak var view: ProfileViewInterface?
    var interactor: ProfileInteractorInput?
    var wireframe: ProfileWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: ProfileStructure) -> ProfileViewModel {
        return ProfileViewModel(name: model.name,
                                gender: model.gender,
                                nickname: model.nickname,
                                musicalInstrument: model.musicalInstrument,
                                postalCode: model.postalCode,
                                age: model.age,
                                email: model.email,
                                profession: model.profession,
                                image: model.image,
                                selfIntroduction: model.selfIntroduction)
    }
    
}

 // MARK: Profile module interface
extension ProfilePresenter: ProfileModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func edit() {
        wireframe?.openEditProfile(profile: interactor?.profile)
    }
    
    
}

// MARK: Profile interactor output interface
extension ProfilePresenter: ProfileInteractorOutput {
    
    func obtained(_ model: ProfileStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
