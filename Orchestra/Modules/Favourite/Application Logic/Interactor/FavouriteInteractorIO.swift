//
//  FavouriteInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//



protocol FavouriteInteractorInput: AnyObject {

    func getFavouriteList(of type: FavouriteType, completion: @escaping (Result<[Favourite], Error>) -> Void)
    func unfavourite(_ model: Orchestra, for type: OrchestraType, completion: @escaping (Result<Favourite, Error>) -> Void)
    func getFavouritePlayerList(param: [String: Any], completion: @escaping (Result<([FavouritePlayer], Pagination?), Error>) -> Void)
    func unfavoritePlayer(of id: Int, completion: @escaping (Result<Favourite, Error>) ->  Void)
    func search(for keyword: String, type: FavouriteType)
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?)
    func unfavourite(of id: Int?, instrumentId: Int?, musicianId: Int?)
  
}

protocol FavouriteInteractorOutput: AnyObject {
    
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtained(_ models: [Favourite])
    func obtained(_ models: [FavouritePlayer])
    func obtained(_ models: [FavouriteStructure], type: OrchestraType)
    func obtained(_ error: Error)
    func obtained(hasMoreData: Bool)
    func obtainedRemove(model: FavouriteStructure)

}
