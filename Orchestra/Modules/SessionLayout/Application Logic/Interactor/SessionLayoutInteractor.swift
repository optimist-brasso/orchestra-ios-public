//
//  SessionLayoutInteractor.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import CoreGraphics
import UIKit.UIScreen

class SessionLayoutInteractor {
    
    var id: Int?
	
    // MARK: Properties
    weak var output: SessionLayoutInteractorOutput?
    private let service: SessionLayoutServiceType
    private var navigationBarHeight: CGFloat?
    private var screenHeight: CGFloat?
    private var screenWidth: CGFloat?
    private var models: [SessionLayout]?
    
    // MARK: Initialization
    init(service: SessionLayoutServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    private func convert(_ model: Session) -> SessionStructure {
        return SessionStructure(image: model.image,
                                layouts: convert(model.layouts ?? []))
    }
    
    private func convert(_ models: [SessionLayout]) -> [SessionLayoutStructure] {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            var copyText = ""
            copyText += "Screen height: \(UIScreen.screenHeight)"
            copyText += "Screen width: \(UIScreen.screenWidth)"
            copyText += "Nav bar height: \(navigationBarHeight ?? .zero)"
            UIPasteboard.general.string = copyText
            let screenHeightForLandscape = getScreenSize.height - (navigationBarHeight ?? .zero)
            let screenWidthForLandscape = (screenHeightForLandscape / GlobalConstants.AspectRatio.sessionBackground.height) * GlobalConstants.AspectRatio.sessionBackground.width
            return calculatePoints(of: models, width: screenWidthForLandscape, height: screenHeightForLandscape)
        case .pad:
            let height = getScreenSize.height - (navigationBarHeight ?? .zero)
            let width = getScreenSize.width
            let heightReaminder = height.truncatingRemainder(dividingBy: GlobalConstants.AspectRatio.sessionBackground.width)
            let widthRemainder = width.truncatingRemainder(dividingBy: GlobalConstants.AspectRatio.sessionBackground.height)
            if widthRemainder <= heightReaminder {
                let screenWidthForLandscape = getScreenSize.width
                let screenHeightForLandscape = (screenWidthForLandscape / GlobalConstants.AspectRatio.sessionBackground.width) * GlobalConstants.AspectRatio.sessionBackground.height
                return calculatePoints(of: models, width: screenWidthForLandscape, height: screenHeightForLandscape)
            } else {
                let screenHeightForLandscape = getScreenSize.height - (navigationBarHeight ?? .zero)
                let screenWidthForLandscape = (screenHeightForLandscape / GlobalConstants.AspectRatio.sessionBackground.height) * GlobalConstants.AspectRatio.sessionBackground.width
                return calculatePoints(of: models, width: screenWidthForLandscape, height: screenHeightForLandscape)
            }
        default:
            return []
        }
    }
    
    private func calculatePoints(of models: [SessionLayout], width: CGFloat, height: CGFloat) -> [SessionLayoutStructure] {
        return  models.map { model -> SessionLayoutStructure in
            let newX = Double(model.x)! * (width / GlobalConstants.AspectRatio.sessionBackground.width)
            let newY = Double(model.y)! * (height / GlobalConstants.AspectRatio.sessionBackground.height)
            let newHeight = model.h * (height / GlobalConstants.AspectRatio.sessionBackground.height)
            let newWidth = model.w * (width / GlobalConstants.AspectRatio.sessionBackground.width)
            return SessionLayoutStructure(x: newX,
                                          y: newY,
                                          height: newHeight,
                                          width: newWidth,
                                          instrument: SessionLayoutInstrumentStructure(id: model.instrumentId,
                                                                                       name: model.instrument,
                                                                                       musicianId: model.musicianId,
                                                                                       player: model.musician,
                                                                                       playerImage: model.musicianImage,
                                                                                       description: model.description,
                                                                                       isBought: model.isPartBought))
        }
    }
    
}

// MARK: SessionLayout interactor input interface
extension SessionLayoutInteractor: SessionLayoutInteractorInput {
    
    func getData(with navigationBarHeight: CGFloat?) {
        self.navigationBarHeight = navigationBarHeight
        let size = getScreenSize
        screenWidth = size.width
        screenHeight = size.height
        if let id = id {
            service.fetchLayoutSession(of: id) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let model):
                    if model.layouts?.isEmpty ?? true {
                        self.output?.obtained(NSError(domain: "instrument-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.noInstrument.value]))
                        return
                    }
//                    if self.service.isLoggedIn {
                        self.service.fetchOrchestraInstrument(of: id) { [weak self] result in
                            switch result {
                            case .success(let models):
                                guard let self = self else {return}
                                self.models = model.layouts
                                self.models?.forEach({ model in
                                    if let index = models.firstIndex(where: {model.instrumentId == $0.id && model.musicianId == $0.musician?.id}) {
                                        let instrumentModel = models.element(at: index)
                                        model.isPartBought = instrumentModel?.isPartBought
                                        model.musicianImage = instrumentModel?.musician?.image
                                    }
                                })
                                self.output?.obtained(self.convert(model))
                            case .failure(let error):
                                self?.output?.obtained(error)
                            }
                        }
//                    } else {
//                        self.output?.obtained(self.convert(model))
//                    }
                case .failure(let error):
                    self.output?.obtained(error)
                }
            }
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendData() {
        GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
    }
    
    func getInstrument(of id: Int, musicianId: Int) {
        guard let orchestraId = self.id else { return }
        service.fetchInstrumentDetail(of: id, in: orchestraId, musicianId: musicianId) { [weak self] result in
            switch result {
            case .success(let model):
                if model.vrFile?.isEmpty ?? true {
                    self?.output?.obtainedMusicianRedirection(of: musicianId)
                    return
                }
                self?.output?.obtainedInstrumentRedirection(id: id, musicianId: musicianId)
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }

    private var getScreenSize: CGSize {
        if #available(iOS 16.0, *) {
            return CGSize(width: UIScreen.screenHeight, height:  UIScreen.screenWidth)
        } else {
            return UIScreen.screenSize
        }
    }
    
}
