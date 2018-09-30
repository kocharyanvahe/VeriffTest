//
//  NavigationHandler.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import UIKit

enum TransitionType {
    case modal
    case push
}

struct ModuleId {
    var storyboardId: String?
    var controllerId: String?
    var transitionType: TransitionType
    
    init(storyboardId: String? = nil,
         controllerId: String? = nil,
         transitionType: TransitionType = .push) {
        self.storyboardId = storyboardId
        self.controllerId = controllerId
        self.transitionType = transitionType
    }
}

protocol ModuleConfiguration {
    
}

protocol TransitionHandler {
    func openModule(with moduleId: ModuleId)
    func closeModule()
}

extension TransitionHandler where Self: UIViewController {
    
    func openModule(with moduleId: ModuleId) {
        switch moduleId.transitionType {
        case .modal:
            if let newViewController = createViewController(with: moduleId) {
                present(newViewController, animated: true, completion: nil)
            }
            
        case .push:
            if let navigationController = self.navigationController,
                let newViewController = createViewController(with: moduleId) {
                navigationController.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    private func createViewController(with moduleId: ModuleId) -> UIViewController? {
        var destinationViewController: UIViewController?
        
        if let storyboardId = moduleId.storyboardId {
            let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
            if let controllerId = moduleId.controllerId {
                destinationViewController = storyboard.instantiateViewController(withIdentifier: controllerId)
            } else {
                destinationViewController = storyboard.instantiateInitialViewController()
            }
        } else {
            if let controllerId = moduleId.controllerId {
                destinationViewController = storyboard?.instantiateViewController(withIdentifier: controllerId)
            } else {
                destinationViewController = storyboard?.instantiateInitialViewController()
            }
        }
        return destinationViewController
    }
    
    func closeModule() {
        dismiss(animated: true, completion: nil)
    }
}
