//
//  Storyboard.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import UIKit

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        guard let vc = storyboard().instantiateInitialViewController() else {
            fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
        }
        return vc
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

struct Storyboard {
    
    enum InitialScreen: String, StoryboardSceneType {
        static let storyboardName = "Main"
        
        case initialViewControllerScene = "InitialScreenStoryboardID"
        static func initialViewController() -> UINavigationController {
            guard let vc = Storyboard.InitialScreen.initialViewControllerScene.viewController() as? UINavigationController else {
                fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
            }
            return vc
        }
    }
    
    enum QRScreen: String, StoryboardSceneType {
        static let storyboardName = "QRScreen"
        
        case qrViewControllerScene = "QRScreenStoryboardID"
        static func initialViewController() -> UINavigationController {
            guard let vc = Storyboard.QRScreen.qrViewControllerScene.viewController() as? UINavigationController else {
                fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
            }
            return vc
        }
    }
}
