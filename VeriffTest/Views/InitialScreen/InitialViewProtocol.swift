//
//  InitialViewProtocol.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

protocol InitialViewProtocol: class {
    func performVeriff(_ url: String)
    func showAlert(_ message: String)
}
