//
//  QRScreenAssembly.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class QRScreenAssembly {
    class func assembly(_ container: Container) {
        container.storyboardInitCompleted(QRScreenController.self) { (resolver, controller) in
            controller.presenter = resolver.resolve(QRScreenPresenter.self, argument: controller as QRScreenProtocol)
        }
        
        container.register(QRScreenPresenter.self, factory: { (resolver, controller : QRScreenProtocol) in
            let presenter = QRScreenPresenterImplementation()
            presenter.router = resolver.resolve(QRScreenRouter.self, argument: controller as QRScreenProtocol)
            return presenter
        }).inObjectScope(ObjectScope.transient)
        
        container.register(QRScreenRouter.self, factory: { (_, controller : QRScreenProtocol) in
            let router = QRScreenRouterImplementation()
            router.transitionHandler = controller
            return router
        }).inObjectScope(ObjectScope.transient)
    }
}

