//
//  SelfieViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 24/10/25.
//

import UIKit
import AVFoundation
import Photos
import SwiftHelperInit

class SelfieViewController: UIViewController {
    private lazy var previewView: UIView? = nil
    private lazy var scanImageView = UIImageView(named: "Scan", contentMode: .scaleAspectFit)
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var photoOutput: AVCapturePhotoOutput?
    private lazy var retakeButton: UIButton? = nil
    private lazy var useButton: UIButton? = nil
    private let sessionQueue = DispatchQueue(label: "selfie.capture.session.queue", qos: .userInitiated)
    
    lazy var selfieImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPreviewUI()
        setupCamera()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep preview layer sized with view
        previewLayer?.frame = view.bounds
    }
    
    deinit {
        stopRunningCamera()
    }
    
    private func stopRunningCamera() {
        // Stop session on background queue
        if captureSession?.isRunning == true {
            sessionQueue.async { [weak captureSession] in
                captureSession?.stopRunning()
            }
        }
    }
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("⚠️ No front camera available")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            let photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
                self.photoOutput = photoOutput
            } else {
                print("⚠️ Cannot add AVCapturePhotoOutput")
            }
            
            // Configure preview layer on main thread
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            self.previewLayer = previewLayer
            DispatchQueue.main.async {
                // Ensure we don't insert multiple times
                if !(self.view.layer.sublayers?.contains(previewLayer) ?? false) {
                    self.view.layer.insertSublayer(previewLayer, at: 0)
                }
            }
            
            startRuningCamera()
            
        } catch {
            print("⚠️ Error setting up camera: \(error)")
        }
    }
    
    private func startRuningCamera() {
        // Start running on background queue
        sessionQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func setupButton() {
        retakeButton = UIButton(title: "retake".translate, style: .init(textColor: .white, backgroundColor: .clear), font: .boldSystemFont(ofSize: 20), onTap: .init(target: self, action: #selector(retakeAction)))
        retakeButton?.alpha = 0
        let captureButton = UIButton(type: .custom)
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        captureButton.layer.borderWidth = 1.5
        captureButton.layer.borderColor = UIColor.primary.cgColor
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        useButton = UIButton(title: "use".translate, style: .init(textColor: .white, backgroundColor: .clear), font: .boldSystemFont(ofSize: 20), onTap: .init(target: self, action: #selector(useAction)))
        useButton?.alpha = 0
        
        let stackView = UIStackView(subViews: [
            UIView(),
            retakeButton!,
            captureButton,
            useButton!,
            UIView()
        ], distribution: .equalSpacing, alignment: .center, axis: .horizontal, spacing: 0)
        
        view.addSubViewWithConstraints(stackView, top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 30, right: 16))
        captureButton.setSize(width: 70, height: 70)
    }
    
    private func setupPreviewUI() {
        previewView = UIView()
        previewView?.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubViewToFill(previewView!)
        
        let label = UILabel(text: "- " + "please_remove_andy_accessories_that_cover_your_face".translate + "\n- " + "align_your_head_inside_the_frame_and_capture_a_clear_image_of_yourself".translate, textColor: .white, numberOfLines: 4, textAlignment: .natural)
        let button = UIButton(title: "ok".translate, font: .boldSystemFont(ofSize: 20), height: 45, onTap: .init(target: self, action: #selector(okAction)))
        
        let previewStackView = UIStackView(subViews: [
            scanImageView,
            UIView(height: 50),
            label,
            UIView(height: 20),
            button
        ], axis: .vertical, spacing: 0)
        
        previewView?.addSubViewWithConstraints(previewStackView, top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        previewStackView.centerYInSuperview()
        let width = view.frame.width/1.8
        scanImageView.setSize(width: width, height: width)
        animateFrameImage()
    }
    
    private func animateFrameImage() {
        UIView.animate(withDuration: 2.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.scanImageView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }
    }
    
    @objc private func okAction() {
        previewView?.removeFromSuperview()
        
        setupButton()
    }
    
    @objc private func capturePhoto() {
        // Ensure session is available
        guard captureSession != nil else {
            setupCamera()
            return
        }
        
        // Ensure photoOutput exists
        if photoOutput == nil {
            let output = AVCapturePhotoOutput()
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
                photoOutput = output
            } else {
                print("⚠️ Cannot add AVCapturePhotoOutput in okAction")
            }
        }
        
        // Trigger capture
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func retakeAction() {
        startRuningCamera()
    }
    
    @objc private func useAction() {
        self.navigationController?.pushViewController(PersonalInfoViewController(), animated: true)
    }
}

extension SelfieViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = photo.fileDataRepresentation() {
            let image = UIImage(data: data)
            selfieImage = image
            stopRunningCamera()
            retakeButton?.alpha = 1
            useButton?.alpha = 1
            print("✅ Captured selfie image: \(String(describing: image?.size))")
        } else if let error = error {
            print("⚠️ Error capturing photo: \(error)")
        }
    }
}
