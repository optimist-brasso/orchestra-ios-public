//
//  PointHistoryInteractor.swift
//  Orchestra
//
//  Created by manjil on 13/12/2022.
//

import Foundation

protocol PointHistoryInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool)

}

protocol PointHistoryInteractorOutput: AnyObject {

    func obtained(_ models: [PointHistory])
    func obtained(_ error: Error)
    func obtained(_ hasMoreData: Bool)
    
}

class PointHistoryInteractor {
    
    // MARK: Properties
    weak var output: PointHistoryInteractorOutput?
    private let service: BillingHistoryServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [PointHistory]()
    
    // MARK: Initialization
    init(service: BillingHistoryServiceType) {
        self.service = service
    }

    
}

// MARK: BillingHistory interactor input interface
extension PointHistoryInteractor: PointHistoryInteractorInput {
    
    func getData(isRefresh: Bool) {
        if isRefresh {
            hasMoreData = true
            isLoading = false
            page = 1
            models.removeAll()
        }
        if !isLoading && hasMoreData {
            isLoading = true
            service.fetchPointHistory(of: page) { [weak self] result in
                switch result {
                case .success((let models, let totalPages)):
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                    self?.output?.obtained(self?.hasMoreData ?? false)
                    self?.models.append(contentsOf: models)
                    self?.output?.obtained(self?.models ?? [])
                case .failure(let error):
                    self?.isLoading = false
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
//    func getData(isRefresh: Bool) {
//        service.fetchPointHistory { [weak self] result in
//            switch result {
//            case .success(let model):
//                    self?.output?.obtained(models: model)
//            case .failure(let error):
//                self?.output?.obtained(error)
//            }
//        }
//    }
    
}
