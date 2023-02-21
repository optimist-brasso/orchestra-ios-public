//
//  FavouritePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import Foundation
import Combine

enum FavoriteFrom {
    case favorite
    case playlist
    case playerDetail
}

enum FavouriteType: Int, CaseIterable {
    
    case conductor, session, hallSound, player
    
    var value: String {
        switch self {
        case .conductor:
            return "conductor"
        case .session:
            return "session"
        case .hallSound:
            return "hall_sound"
        case .player:
            return "player"
        }
    }
    
    static func getType(value: String) -> FavouriteType {
        switch value {
        case FavouriteType.conductor.value:
            return .conductor
        case FavouriteType.session.value:
            return .session
        case FavouriteType.hallSound.value:
            return .conductor
        case FavouriteType.player.value:
            return .conductor
        default:
            fatalError("THERE IS NO \(value)")
        }
    }
    
}

struct FullFavoriteList {
    let type: FavouriteType
    var  data: [Favourable]
}

class FavouritePresenter {
    
    // MARK: Properties
    weak var view: FavouriteViewInterface?
    var interactor: FavouriteInteractorInput?
    var wireframe: FavouriteWireframeInput?
    var favouriteList: [Favourite] = []
    var favouritePlayerList: [FavouritePlayer]  = []
    var fullList = [FullFavoriteList(type: .conductor, data: []),
                    FullFavoriteList(type: .session, data: []),
                    FullFavoriteList(type: .hallSound, data: []),
                    FullFavoriteList(type: .player, data: [])]
    var islastPlayerPage = false
    var currentPlayerPage = 0
    var list = CurrentValueSubject<[Favourable], Never>([])
    var response = PassthroughSubject<(success: Bool, error: String), Never>()
    var sessionList: [FavouriteStructure] = []
    private var openMode: OpenMode?
    
    //MARK: Converting functions
    private func convert(_ models: [FavouriteStructure]) -> [FavouriteViewModel] {
        models.map({
            return FavouriteViewModel(id: $0.id,
                                      image: $0.image,
                                      title: $0.title,
                                      titleJapanese: $0.titleJapanese,
                                      isSessionFavourite: $0.isSessionFavourite,
                                      musicianId: $0.musicianId,
                                      playerName: $0.playerName,
                                      instrumentId: $0.instrumentId,
                                      instrument: $0.instrument,
                                      conductorImage: $0.conductorImage,
                                      sessionImage: $0.sessionImage,
                                      venueDiagram: $0.venueDiagram)})
    }
    
}

// MARK: Favourite module interface
extension FavouritePresenter: FavouriteModuleInterface {
    
    func getFavoritePlayer(search: String, type: FavouriteType) {
        if islastPlayerPage {
            return
        }
        interactor?.getFavouritePlayerList(param:  ["page": "\(currentPlayerPage + 1)" ], completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let object, let page)):
                if let page = page {
                    if  page.currentPage == 1 {
                        self.favouritePlayerList = []
                    }
                    self.currentPlayerPage =  page.currentPage ?? 1
                    self.islastPlayerPage =  self.currentPlayerPage ==  (page.totalPages ?? 1)
                }
                self.favouritePlayerList += object
                self.getSelected(type: .player, search: search)
            case .failure(let error):
                self.view?.show(error)
            }
        })
    }
    
    func reloadPlayerList() {
        interactor?.getFavouritePlayerList(param:  ["page": "1"], completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let object, _)):
                self.favouritePlayerList = []
                self.favouritePlayerList += object
                self.fullList[FavouriteType.player.rawValue].data = self.favouritePlayerList
                self.getSelected(type: .player, search: "")
            case .failure(let error):
                self.view?.show(error)
            }
        })
    }
    
    func unfavoritePlayer(id: Int, search: String) {
        view?.showLoading()
        interactor?.unfavoritePlayer(of: id, completion: { [weak self] result in
            guard let self = self else  {  return }
            self.view?.hideLoading()
            switch result {
            case .success(let message):
                print(message)
                self.remove(id: id, type: FavouriteType.player.value, search: search)
            case .failure(let error):
                self.view?.show(error)
                self.response.send((false, error.localizedDescription))
            }
        })
    }
    
    func makeUnFavorite(id: Int, type: String, search: String) {
        view?.showLoading()
        let type = OrchestraType(rawValue: type) ?? .conductor
        var index: Int? {
            switch type {
            case .conductor:
                return FavouriteType.conductor.rawValue
            case .session:
                return FavouriteType.session.rawValue
            case .hallSound:
                return FavouriteType.hallSound.rawValue
            case .player:
                return FavouriteType.player.rawValue
            }
        }
        guard let index = index else { return }
        let models = fullList.element(at: index)?.data
        guard let model = models?.first(where: {$0.id == id}) as? Favourite else { return }
        let orchestra = Orchestra()
        orchestra.id = model.id
        orchestra.title = model.title
        orchestra.titleJapanese = model.jpTitle
        orchestra.releaseDate = model.recordTime
        orchestra.duration = model.duration
        orchestra.image = model.image
        orchestra.tags = model.tags
        interactor?.unfavourite(orchestra, for: type, completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.remove(id: id, type: type.rawValue, search: search)
            case .failure(let error):
                self?.response.send((false, error.localizedDescription))
            }
        })
    }
    
    func remove(id: Int, type: String, search: String) {
        if let orchestraType = OrchestraType(rawValue: type) {
            let orchestraFavorite = OrchestraFavorite(id: id, type: orchestraType, interactor: nil)
            NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: orchestraFavorite)
        }
       
        if type == FavouriteType.player.value {
            if  let index = favouritePlayerList.firstIndex(where: { $0.id == id }) {
                favouritePlayerList.remove(at: index)
                getSelected(type:  .player, search: "")
            }
            return
        }
        if  let index = favouriteList.firstIndex(where: { $0.id == id && $0.type == type }) {
            favouriteList.remove(at: index)
            getSelected(type: FavouriteType.getType(value: type), search: search)
        }
        
    }
    
    func getFavorite(type: FavouriteType = .conductor, search: String) {
        interactor?.getFavouriteList(of: type, completion: { [weak self] result in
            guard let self = self else { return }
            self.getFavoritePlayer(search: "", type: .player)
            switch result {
            case .success(let object):
                self.favouriteList = object
                self.getSelected(type: type, search: "")
            case .failure(let error):
                self.view?.show(error)
            }
        })
    }
    
    func getSelected(type: FavouriteType, search: String) {
        if type == .player {
            fullList[FavouriteType.player.rawValue].data = favouritePlayerList
        } else {
            fullList[FavouriteType.conductor.rawValue].data = favouriteList.filter { $0.type == FavouriteType.conductor.value }
            fullList[FavouriteType.session.rawValue].data = favouriteList.filter { $0.type == FavouriteType.session.value }
            fullList[FavouriteType.hallSound.rawValue].data = favouriteList.filter { $0.type == FavouriteType.hallSound.value }
        }
        list.send([])
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        wireframe?.openCart()
    }
    
    func details(of id: Int, type: OrchestraType) {
        wireframe?.openDetails(of: id, type: type)
    }
    
    func search(for keyword: String, type: FavouriteType, isLoading: Bool) {
        if isLoading {
            view?.showLoading()
        }
        interactor?.search(for: keyword, type: type)
    }
    
    func viewIsReady(showLoading: Bool, isRefreshed: Bool, type: OrchestraType, keyword: String?) {
        if showLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed, type: type, keyword: keyword)
    }
    
    func unfavourite(of id: Int?, instrumentId: Int?, musicianId: Int?) {
        view?.showLoading()
        interactor?.unfavourite(of: id, instrumentId: instrumentId, musicianId: musicianId)
    }
    
    func instrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?) {
        wireframe?.openInstrumentDetail(of: id, orchestraId: orchestraId, musicianId: musicianId)
    }
    
}

// MARK: Favourite interactor output interface
extension FavouritePresenter: FavouriteInteractorOutput {
    
    func obtainedRemove(model: FavouriteStructure) {
        let viewModel = FavouriteViewModel(id: model.id,
                                           image: model.image,
                                           title: model.title,
                                           titleJapanese: model.titleJapanese,
                                           isSessionFavourite: model.isSessionFavourite,
                                           musicianId: model.musicianId,
                                           playerName: model.playerName,
                                           instrumentId: model.instrumentId,
                                           instrument: model.instrument)
        view?.remove(model: viewModel)
        view?.hideLoading()
    }

    func obtained(_ models: [Favourite]) {
        fullList[FavouriteType.conductor.rawValue].data = models.filter { $0.type == FavouriteType.conductor.value }
        fullList[FavouriteType.session.rawValue].data = models.filter { $0.type == FavouriteType.session.value }
        fullList[FavouriteType.hallSound.rawValue].data = models.filter { $0.type == FavouriteType.hallSound.value }
        list.send([])
    }
    
    func obtained(_ models: [FavouritePlayer]) {
        fullList[FavouriteType.player.rawValue].data =  models
        list.send([])
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ models: [FavouriteStructure], type: OrchestraType) {
        sessionList = models
        view?.show(convert(models), type: type)
    }
    
    func obtained(hasMoreData: Bool) {
        view?.show(hasMoreData: hasMoreData)
    }
    
}
