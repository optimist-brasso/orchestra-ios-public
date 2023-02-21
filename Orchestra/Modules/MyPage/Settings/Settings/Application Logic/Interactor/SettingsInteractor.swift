//
//  SettingsInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class SettingsInteractor {
    
	// MARK: Properties
    weak var output: SettingsInteractorOutput?
    private let service: SettingsServiceType
    
    // MARK: Initialization
    init(service: SettingsServiceType) {
        self.service = service
    }
    
}

// MARK: Settings interactor input interface
extension SettingsInteractor: SettingsInteractorInput {
    
    func getData() {
        let profile = service.profile
        output?.obtained(SettingsStructure(notificationStatus: profile?.notificationStatus ?? true,
                                          version: "Ver. \(Bundle.main.releaseVersionNumber)",
                                           isLoggedIn: service.isLoggedIn))
    }
    
    func toggleNotificationStatus() {
        service.toggle { [weak self] result in
            switch result {
            case .success(_):
                if let model = self?.service.profile {
                    DispatchQueue.main.async {
                        DatabaseHandler.shared.update {
                            model.notificationStatus?.toggle()
                        }
                        DatabaseHandler.shared.writeObjects(with: [model])
                    }
                }
            case .failure(let error):
                if error.localizedDescription == LocalizedKey.noInternet.value {
                    self?.output?.obtained(error)
                    if let model = self?.service.profile {
                        self?.output?.obtained(toggle: model.notificationStatus ?? false)
                    }
                }
                print(error.localizedDescription)
            }
        }
    }
    
}
