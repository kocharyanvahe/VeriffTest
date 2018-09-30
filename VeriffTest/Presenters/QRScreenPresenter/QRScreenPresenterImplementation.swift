//
//  QRScreenPresenterImplementation.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

final class QRScreenPresenterImplementation: QRScreenPresenter {
    
    var router: QRScreenRouter!
    
    func closeQRScreen() {
        router.closeButtonAction()
    }
}
