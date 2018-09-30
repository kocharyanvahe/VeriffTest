//
//  InitialScreenPresenter.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

protocol InitialScreenPresenter {
    func scanQRAction()
    func verifyAction(_ selectedSegmentIndex: Int)
    func showAlertAction()
}
