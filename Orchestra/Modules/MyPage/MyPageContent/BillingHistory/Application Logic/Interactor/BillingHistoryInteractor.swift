//
//  BillingHistoryInteractor.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

import Foundation

class BillingHistoryInteractor {
    
    // MARK: Properties
    weak var output: BillingHistoryInteractorOutput?
    private let service: BillingHistoryServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [BillingHistory]()
    
    // MARK: Initialization
    init(service: BillingHistoryServiceType) {
        self.service = service
    }
    
    // MARK: Converting entities
    private func convert(_ models: [BillingHistory]) -> [BillingHistoryStructure] {
        return models.map({
            let date = DateFormatter.toDate(dateString: $0.date ?? "", format: "MM/dd/yyyy", timeZone: .utc) ?? Date()
            return BillingHistoryStructure(title: "\($0.title ?? "")/\($0.japaneseTitle ?? "")",
                                           date: DateFormatter.toString(date: date, format: "yyyy.M.d"),
                                           price: $0.price,
                                           type: OrchestraType(rawValue: $0.type ?? ""),
                                           instrument: $0.instrument,
                                           isPremium: $0.isPremium,
                                           sessionType: SessionType(rawValue: $0.sessionType ?? ""),
                                           musician: $0.musician)})
    }
    
    private func convertTotal(_ models: [BillingHistory]) -> Double {
        return models.map({$0.price ?? 0}).reduce(0, +)
    }
    
    private func filterArrayByDate(_ models: [BillingHistory]) {
        let outputModel = Dictionary(grouping: models, by: { $0.date?.formattedDate })
        let sortedModel = outputModel.sorted(by: { DateFormatter.toDate(dateString: $0.key ?? "", format: "MM/yyyy", timeZone: .utc)! >
            DateFormatter.toDate(dateString: $1.key ?? "", format: "MM/yyyy")! })
        let models: [BillingHistoryMonthlyStructure] = sortedModel.map({
            let dateString = $0.key?.wordsFormattedDate?.components(separatedBy: "/") ?? []
            let year = dateString.first ?? ""
            let month = dateString.last ?? ""
            return BillingHistoryMonthlyStructure(date: "\(year)\(LocalizedKey.year.value)\(month)\(LocalizedKey.month.value)",
                                                  items: convert($0.value),
                                                  total: convertTotal($0.value))})
        output?.obtained(models)
    }
    
}

// MARK: BillingHistory interactor input interface
extension BillingHistoryInteractor: BillingHistoryInteractorInput {
    
    func getData(isRefresh: Bool) {
        if isRefresh {
            hasMoreData = true
            isLoading = false
            page = 1
            models.removeAll()
        }
        if !isLoading && hasMoreData {
            isLoading = true
            service.fetchBillingHistory(of: page) { [weak self] result in
                switch result {
                case .success((let models, let totalPages)):
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                    self?.output?.obtained(self?.hasMoreData ?? false)
                    self?.models.append(contentsOf: models)
                    self?.filterArrayByDate(self?.models ?? [])
                case .failure(let error):
                    self?.isLoading = false
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
}
