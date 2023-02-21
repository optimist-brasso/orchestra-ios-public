//
//  PurchasedContentListInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class PurchasedContentListInteractor {
    
    // MARK: Properties
    weak var output: PurchasedContentListInteractorOutput?
    private let service: PurchasedContentListServiceType
    private var models = [Orchestra]()
    private var newModels: Purchased?
    
    // MARK: Initialization
    init(service: PurchasedContentListServiceType) {
        self.service = service
    }
    
    // MARK: Converting entities
    private func convert(_ models: [Orchestra]) -> [PurchasedContentListStructure] {
        return models.map({PurchasedContentListStructure(title: $0.title,
                                                         titleJapanese: $0.titleJapanese,
                                                         releaseDate: $0.releaseDate,
                                                         duration: $0.duration?.time,
                                                         image: $0.image)})
    }
    
}

// MARK: PurchasedContentList interactor input interface
extension PurchasedContentListInteractor: PurchasedContentListInteractorInput {
    
    func getData() {
        service.fetchPurchaseList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                //   self?.models = models
                // self?.output?.obtained(self?.convert(models) ?? [])
                self.newModels = models
                self.output?.obtained(self.convert(purchased: models))
            case .failure(let error):
                self.output?.obtained(error)
            }
        }
    }
    
    func search(for keyword: String) {
        guard let purchased = self.newModels else { return }
        if keyword.isEmpty {
            output?.obtained(convert(purchased: purchased))
            return
        }
//        let (prefixListModels, containListModels) = models.reduce(([Orchestra](), [Orchestra]())) { (result, element) in
//            if element.title?.lowercased().hasPrefix(keyword.lowercased()) == true {
//                return (result.0 + [element], result.1)
//            } else if element.title?.lowercased().contains(keyword.lowercased()) == true {
//                return (result.0, result.1  + [element])
//            }
//            return (result.0, result.1)
//        }
//        let sortedPrefixList = prefixListModels.sorted(by: {$0.title ?? "" < $1.title ?? ""})
//        let sortedContainList = containListModels.sorted(by: {$0.title ?? "" < $1.title ?? ""})
//        let overallList = sortedPrefixList + sortedContainList
//        output?.obtained(convert(overallList))
        
        var filter = purchased
        filter.part = purchased.part.filter { $0.title.lowercased().contains(keyword.lowercased()) || $0.titleJapanese.lowercased().contains(keyword.lowercased()) || $0.instrumentTitle.lowercased().contains(keyword.lowercased())  }
      
        filter.premium = purchased.premium.filter { $0.title.lowercased().contains(keyword.lowercased()) || $0.titleJapanese.lowercased().contains(keyword.lowercased()) || $0.instrumentTitle.lowercased().contains(keyword.lowercased())  }
        
        filter.hallSound = purchased.hallSound.filter { $0.title.lowercased().contains(keyword.lowercased()) || $0.titleJapanese.lowercased().contains(keyword.lowercased())   }
        
        filter.conductor = purchased.conductor.filter { $0.title.lowercased().contains(keyword.lowercased()) || $0.titleJapanese.lowercased().contains(keyword.lowercased())   }
        
        self.output?.obtained(self.convert(purchased: filter))
        
    }
    
    func convert(purchased: Purchased) -> [PurchasedModel] {
        var model = [PurchasedModel]()
        if !purchased.part.isEmpty {
            model.append(PurchasedModel(title: "part", jpTitle: "セッション", model: purchased.part))
        }
        if !purchased.premium.isEmpty {
            model.append(PurchasedModel(title: "premium", jpTitle: "PREMIUM映像", model: purchased.premium))
        }
        if !purchased.hallSound.isEmpty {
            model.append(PurchasedModel(title: "hall sound", jpTitle: "ホールサウンド", model: purchased.hallSound))
        }
        if !purchased.conductor.isEmpty {
            model.append(PurchasedModel(title: "conductor", jpTitle: "コンダクター", model: purchased.conductor))
        }
        return model
    }
    
}


struct PurchasedModel {
    var title: String
    var jpTitle: String
    var model: [Purchasable]
    
}
