//
//  CheckStatusVC.swift
//  Immuni
//
//  Created by Lorenzo Spinucci on 03/03/21.
//

//
//  import AVFoundation .swift
//  DebugMenu
//
//  Created by Lorenzo Spinucci on 01/03/21.
//

import AVFoundation
import Foundation
import Katana
import Tempura
import UIKit
import Models
import Networking

class CheckStatusVC: ViewControllerWithLocalState<CheckStatusView>,
    AVCaptureMetadataOutputObjectsDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        captureSession?.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            self.dispatch(Logic.DataUpload.ShowConfirmScanAlert(message: stringValue))
        }

        var layer: CALayer? = view.layer.sublayers?.last
        layer?.removeFromSuperlayer()

        dismiss(animated: true)
    }

    func found(code: String) {
        print("QrCode", code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func scan() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession!.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

//        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        guard let captureSession = captureSession else { return }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)

        captureSession.startRunning()
    }

    override func setupInteraction() {
        rootView.didTapBack = { [weak self] in
            self?.dispatch(Hide(Screen.checkStatus, animated: true))
        }

        rootView.didTapScanAction = { [weak self] in
            self?.scan()
        }
        rootView.didTapUploadAction = { [weak self] in
//            self?.dispatch(Logic.DataUpload.ConfirmDataQr())
//            try context.awaitDispatch(ShowConfirmData(code: self.code))
        }

    }
}

// MARK: - LocalState

struct CheckStatusLS: LocalState {}
