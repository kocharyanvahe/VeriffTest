//
//  QRScreenController.swift
//  VeriffTest
//
//  Created by Vahe on 9/27/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import UIKit
import AVFoundation

class QRScreenController: UIViewController, QRScreenProtocol, TransitionHandler {
    
    var presenter: QRScreenPresenter!
    
    private let supportedTypes = [AVMetadataObject.ObjectType.qr]
    private var qrView: UIView?
    private var captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    private func viewIsReady() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failing to start camera.")
            return
        }
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedTypes
        } catch {
            print(error)
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
        qrView = UIView()
        if let qrView = qrView {
            qrView.layer.borderColor = UIColor.red.cgColor
            qrView.layer.borderWidth = 2
            view.addSubview(qrView)
        }
    }
    
    func qrDetected(_ decodedURL: String) {
        if presentedViewController != nil {
            return
        }
        let title = NSLocalizedString(Messages.openAppTitle.rawValue, comment: "")
        let message = "\(NSLocalizedString(Messages.tokenQuestion.rawValue, comment: "")) \(decodedURL)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: NSLocalizedString(Messages.confirmTitle.rawValue, comment: ""), style: .default) { _ in
            Session.sessionToken = decodedURL
            self.presenter.closeQRScreen()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString(Messages.cancelTitle.rawValue, comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: UIBarButtonItem) {
        presenter.closeQRScreen()
    }
}

extension QRScreenController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedTypes.contains(metadataObj.type) {
            let qrCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrView?.frame = qrCodeObject!.bounds
            if metadataObj.stringValue != nil {
                qrDetected(metadataObj.stringValue!)
            }
        }
    }
}
