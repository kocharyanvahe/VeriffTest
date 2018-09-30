//
//  SwinjectStoryboardSetup.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        Container.loggingFunction = nil
        
        // InitialScreenAssembly module
        InitialScreenAssembly.assembly(defaultContainer)
        
        // QRScreenAssembly module
        QRScreenAssembly.assembly(defaultContainer)
    }
}
