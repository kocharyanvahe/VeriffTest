//
//  InitialScreenAssembly.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class InitialScreenAssembly {
    class func assembly(_ container: Container) {
        container.storyboardInitCompleted(InitialViewController.self) { (resolver, controller) in
            controller.presenter = resolver.resolve(InitialScreenPresenter.self, argument: controller as InitialViewProtocol)
        }
        
        container.register(InitialScreenPresenter.self, factory: { (resolver, controller : InitialViewProtocol) in
            let presenter = InitialScreenPresenterImplementation()
            presenter.view = controller
            presenter.router = resolver.resolve(InitialScreenRouter.self, argument: controller as InitialViewProtocol)
            return presenter
        }).inObjectScope(ObjectScope.transient)
        
        container.register(InitialScreenRouter.self, factory: { (_, controller : InitialViewProtocol) in
            let router = InitialScreenRouterImplementation()
            router.transitionHandler = controller
            return router
        }).inObjectScope(ObjectScope.transient)
    }
}
