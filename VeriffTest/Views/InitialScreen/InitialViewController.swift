//
//  InitialViewController.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import UIKit
import Veriff

class InitialViewController: UIViewController, InitialViewProtocol, TransitionHandler {
    
    var presenter: InitialScreenPresenter!
    
    @IBOutlet weak var qrCodeField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        qrCodeField.text = Session.sessionToken
    }
    
    @IBAction func scanQRTapped(_ sender: UIButton) {
        presenter.scanQRAction()
    }
    
    @IBAction func startVeriffyTapped(_ sender: UIButton) {
        isTextFieldNotEmpty() ? presenter.verifyAction(segmentedControl.selectedSegmentIndex) : presenter.showAlertAction()
    }
    
    func performVeriff(_ url: String) {
        guard let decodedToken = qrCodeField.text else { return }
        Veriff.configure { configuration in
            configuration.sessionUrl = url
            configuration.sessionToken = decodedToken
        }
        Veriff.createColorSchema { schema in
            schema.headerColor = UIColor.darkGray.withAlphaComponent(0)
            schema.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
            schema.footerColor = UIColor.darkGray.withAlphaComponent(0)
            schema.controlsColor = #colorLiteral(red: 0.9200871587, green: 0.103684105, blue: 0.2260400355, alpha: 1)
            schema.hintFooterColor = #colorLiteral(red: 0.9200871587, green: 0.103684105, blue: 0.2260400355, alpha: 1)
        }
        Veriff.setBackgroundImage("camera")
        let veriff = Veriff.sharedInstance()
        veriff.setResultBlock { [unowned self] (sessionUrl, result) in
            self.showAlert(result.description)
        }
        veriff.requestViewController(completion: { (veriffVewController) in
            self.present(veriffVewController, animated:true, completion:nil)
        })
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: NSLocalizedString(Messages.alertTitle.rawValue, comment: ""), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString(Messages.okTitle.rawValue, comment: ""), style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    private func isTextFieldNotEmpty() -> Bool {
        guard let isQRTextFieldEmpty = qrCodeField.text?.isEmpty, !isQRTextFieldEmpty else {
            return false
        }
        return true
    }
}

extension InitialViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
