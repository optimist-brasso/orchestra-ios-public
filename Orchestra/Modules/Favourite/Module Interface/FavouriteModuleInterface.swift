//
//  FavouriteModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import Combine

protocol FavouriteModuleInterface: AnyObject {
    
    var sessionList: [FavouriteStructure] {get set}
    var favouriteList: [Favourite] { get set}
    var fullList: [FullFavoriteList] {get set }
    var islastPlayerPage: Bool {get set}
    var favouritePlayerList: [FavouritePlayer] { get set}
    var list: CurrentValueSubject<[Favourable], Never> { get set }
    var response: PassthroughSubject<(success: Bool, error: String), Never> { get set }
    var currentPlayerPage: Int { get set }
    func notification()
    func getFavorite(type: FavouriteType, search: String)
    func makeUnFavorite(id: Int, type: String, search: String)
    func getFavoritePlayer(search: String, type: FavouriteType)
    func unfavoritePlayer(id: Int, search: String)
    func getSelected(type: FavouriteType, search: String)
    func unfavourite(of id: Int?, instrumentId: Int?, musicianId: Int?)
    func cart()
    func details(of id: Int, type: OrchestraType)
    func search(for keyword: String, type: FavouriteType, isLoading: Bool)
    func reloadPlayerList()
    func viewIsReady(showLoading: Bool, isRefreshed: Bool, type: OrchestraType, keyword: String?)
    func instrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?)
    
}
