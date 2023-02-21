//
//  SettingsWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit
import XLPagerTabStrip

class SettingsWireframe {
    
    weak var view: UIViewController!
    private lazy var streamingDownloadSettingsWireframe: StreamingDownloadSettingsWireframeInput = {StreamingDownloadSettingsWireframe()}()
    private lazy var recordingSettingsWireframe: RecordingSettingsWireframeInput = {RecordingSettingsWireframe()}()
    private lazy var dataManagementWireframe: DataManagementSettingsWireframeInput = {DataManagementSettingsWireframe()}()
    
}

extension SettingsWireframe: SettingsWireframeInput {
    
    var storyboardName: String {return "Settings"}
    
    func getMainView() -> UIViewController {
        let service = SettingsService()
        let interactor = SettingsInteractor(service: service)
        let presenter = SettingsPresenter()
        let screen = SettingsScreen()
        let viewController = SettingsViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openStreamingDownloadSettings() {
        streamingDownloadSettingsWireframe.pushMainView(on: view)
    }
    
    func openRecordingSettings() {
        recordingSettingsWireframe.pushMainView(on: view)
    }
    
    func openDataManagementSettings() {
        dataManagementWireframe.pushMainView(on: view)
    }
    
}

class MyPageSettingsNavigationBarController: UINavigationController, IndicatorInfoProvider  {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: LocalizedKey.settings.value, image: GlobalConstants.Image.settings, highlightedImage: nil, userInfo: false)
    }
    
}
