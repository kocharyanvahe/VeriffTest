//
//  QRScreenRouterImplementation.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

final class QRScreenRouterImplementation: QRScreenRouter {
    
    weak var transitionHandler: QRScreenProtocol!
    
    func closeButtonAction() {
        guard let transitionHandler = transitionHandler as? TransitionHandler else { return }
        transitionHandler.closeModule()
    }
}
