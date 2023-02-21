//
//  RecordingListPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class RecordingListPresenter {
    
	// MARK: Properties
    weak var view: RecordingListViewInterface?
    var interactor: RecordingListInteractorInput?
    var wireframe: RecordingListWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [RecordingListStructure]) -> [RecordingListViewModel] {
        return models.map({RecordingListViewModel(title: $0.title,
                                                  edition: $0.edition,
                                                  date: $0.date,
                                                  duration: $0.duration,
                                                  image: $0.image,
                                                  path: $0.path)})
    }
    
}

 // MARK: RecordingList module interface
extension RecordingListPresenter: RecordingListModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, keyword: String?) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed, keyword: keyword)
    }
    
    func openRecordPlayer(of index: Int) {
        wireframe?.openRecordPlayer()
        interactor?.openRecordPlayer(of: index)
    }
    
}

// MARK: RecordingList interactor output interface
extension RecordingListPresenter: RecordingListInteractorOutput {
    
    func obtained(_ models: [RecordingListStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ hasMoreData: Bool) {
        view?.show(hasMoreData)
    }
    
}
