//
//  InitialScreenRouterImplementation.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

final class InitialScreenRouterImplementation: InitialScreenRouter {
    
    weak var transitionHandler: InitialViewProtocol!
    
    func openQRDetectionScreen() {
        guard let transitionHandler = transitionHandler as? TransitionHandler else { return }
        let moduleId = ModuleId(storyboardId: Storyboard.QRScreen.storyboardName, controllerId: Storyboard.QRScreen.qrViewControllerScene.rawValue, transitionType: .modal)
        transitionHandler.openModule(with: moduleId)
    }
}
