//
//  InstrumentPlayerInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

import Foundation

class InstrumentPlayerInteractor {
    
    // MARK: Properties
    weak var output: InstrumentPlayerInteractorOutput?
    private let service: InstrumentPlayerServiceType
    private var model: Instrument?
    private var models: [SessionLayout]?
    var sessionType: SessionType = .part
    var isAppendixVideo = false
    
    // MARK: Initialization
    init(service: InstrumentPlayerServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSessionLayout(_:)), name: GlobalConstants.Notification.getSessionLayout.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.sendVRData.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Instrument) -> InstrumentPlayerStructure {
        return InstrumentPlayerStructure(title: model.orchestra?.title,
                                         japaneseTitle: model.orchestra?.titleJapanese,
                                         instrument: model.name,
                                         businessType: model.orchestra?.businessType,
//                                         videoURL: model.partVRPath ?? model.vrFile,
//                                         videoURL: sessionType == .premium && isAppendixVideo ? (model.premiumVRPath ?? model.appendixFile) : (model.partVRPath ?? model.vrFile),
                                         videoURL: model.orchestra?.vrPath,
                                         isPartBought: model.isPartBought,
                                         isPremiumBought: model.isPremiumBought,
                                         leftViewAngle: model.leftViewAngle,
                                         rightViewAngle: model.rightViewAngle)
    }
    
    //MARK: Other functions
    @objc private func didGetInstrument(_ notification: Notification) {
        if let model = notification.object as? Instrument {
            guard self.model == nil else { return }
            self.model = model
            getData()
        }
    }
    
    @objc private func didBuy(_ notification: Notification) {
        if let model = model, let purchasedItems = notification.object as? [CartItem],
           let musicianId = model.musician?.id,
           let orchestraId = model.orchestra?.id,
           let index = purchasedItems.firstIndex(where: {musicianId == $0.musicianId &&
               orchestraId == $0.orchestraId &&
               ($0.sessionType == sessionType.rawValue || $0.sessionType == SessionType.combo.rawValue) &&
               $0.orchestraType == OrchestraType.session.rawValue}),
        let purchasedItem = purchasedItems.element(at: index) {
            if sessionType == .part {
                output?.obtainedBuySuccess()
            } else {
                if purchasedItem.sessionType == SessionType.premium.rawValue {
                    model.isPremiumBought = true
                } else if purchasedItem.sessionType == SessionType.combo.rawValue {
                    model.isPartBought = true
                    model.isPremiumBought = true
                }
                output?.obtained(convert(model))
            }
        }
    }
    
    @objc private func didGetSessionLayout(_ notification: Notification) {
        if models == nil, let models = notification.object as? [SessionLayout] {
            self.models = models
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: InstrumentPlayer interactor input interface
extension InstrumentPlayerInteractor: InstrumentPlayerInteractorInput {
    
    func sendRecordedAudio(title: String, id: Int, duration: Int, file: AudioFile) {
        service.sendRecordedAudio(title: title,
                                  id: id,
                                  date: Date().toString(format: .dashYYYYMMDD),
                                  duration: duration,
                                  file: file) { [weak self] result in
            switch result {
            case .success(let model):
                print("data success: \(model)   ---------->")
                self?.output?.audioFileUploaded()
            case .failure(let error):
                print("error: \(error.localizedDescription)   ---------->")
            }
        }
    }
    
    func getData() {
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    func sendData() {
        if let model = model {
            GlobalConstants.Notification.getInstrument.fire(withObject: model)
            GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
        }
    }
    
}
