//
//  InitialScreenPresenterImplementation.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

final class InitialScreenPresenterImplementation: InitialScreenPresenter {
    
    var router: InitialScreenRouter!
    var view: InitialViewProtocol!
    
    func scanQRAction() {
        router.openQRDetectionScreen()
    }
    
    func verifyAction(_ selectedSegmentIndex: Int) {
        let url: String
        switch selectedSegmentIndex {
        case 0:
            url = API.createUrl(hosting: .sandbox)
        case 1:
            url = API.createUrl(hosting: .staging)
        case 2:
            url = API.createUrl(hosting: .magic)
        default:
            url = API.createUrl(hosting: .sandbox)
        }
        view.performVeriff(url)
    }
    
    func showAlertAction() {
        let message = NSLocalizedString(Messages.scanQRCode.rawValue, comment: "")
        view.showAlert(message)
    }
}
