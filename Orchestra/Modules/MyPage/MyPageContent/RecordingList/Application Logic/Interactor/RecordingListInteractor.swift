//
//  RecordingListInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class RecordingListInteractor {
    
	// MARK: Properties
    weak var output: RecordingListInteractorOutput?
    private let service: RecordingListServiceType
    private var page: Int = 1
    private var hasMoreData = true
    private var isLoading = false
    private var models = [Recording]()
    private var keyword: String?
    
    // MARK: Initialization
    init(service: RecordingListServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    private func convert(_ models: [Recording]) -> [RecordingListStructure] {
        return models.map({
            let date = DateFormatter.toDate(dateString: $0.date ?? "", format: "yyyy-MM-dd HH:mm", timeZone: .utc) ?? Date()
            let dateString = DateFormatter.toString(date: date, format: "yyyy-MM-dd HH:mm")
            return RecordingListStructure(title: $0.title,
                                          edition: $0.edition,
                                          date: $0.date?.isEmpty ?? true ? nil : "REC \(dateString)",
                                          duration: (($0.duration ?? .zero) / 1000).time,
                                          image: $0.image,
                                          path: $0.path)})
    }
    
}

// MARK: RecordingList interactor input interface
extension RecordingListInteractor: RecordingListInteractorInput {
    
    func getData(isRefresh: Bool, keyword: String?) {
        if let keyword = keyword, self.keyword != keyword {
            self.keyword = keyword
        }
        if isRefresh {
            hasMoreData = true
            isLoading = false
            page = 1
            models.removeAll()
        }
        if !isLoading && hasMoreData {
            isLoading = true
            service.fetchRecordingList { [weak self] result in
                switch result {
                case .success((let models, let totalPages)):
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                    self?.output?.obtained(self?.hasMoreData ?? true)
                    self?.models.append(contentsOf: models)
                    self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                case .failure(let error):
                    self?.isLoading = false
                    self?.output?.obtained(error)
                }
            }
        }
        
    }
    
    func openRecordPlayer(of index: Int) {
        let model = models.element(at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayRecordingInRecordPlayer"), object: model)
    }
    
}
