//
//  SelfieViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 24/10/25.
//

import UIKit
import AVFoundation
import Photos

class SelfieViewController: UIViewController {
    
    // MARK: - UI
    private let previewView = UIView()
    private let captureButton = UIButton(type: .custom)
    private let switchCameraButton = UIButton(type: .system)
    private let overlayView = UIView()
    private let frameLayer = CAShapeLayer()
    private let previewImageView = UIImageView()
    private let retakeButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    
    // MARK: - AVFoundation
    private let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // prefer front camera
    private var currentCameraPosition: AVCaptureDevice.Position = .front
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        checkCameraAuthorizationAndConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
        updateOverlayPath()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // preview container
        previewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewView)
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            // give a 4:5 camera preview height or whatever you prefer
            previewView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4.0/5.0)
        ])
        
        // capture button
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.layer.cornerRadius = 36
        captureButton.backgroundColor = .white
        captureButton.layer.borderColor = UIColor.lightGray.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.addTarget(self, action: #selector(didTapCapture), for: .touchUpInside)
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 24),
            captureButton.widthAnchor.constraint(equalToConstant: 72),
            captureButton.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        // switch camera
        switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
        switchCameraButton.setTitle("Flip", for: .normal)
        switchCameraButton.setTitleColor(.white, for: .normal)
        switchCameraButton.addTarget(self, action: #selector(didTapSwitchCamera), for: .touchUpInside)
        view.addSubview(switchCameraButton)
        NSLayoutConstraint.activate([
            switchCameraButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            switchCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        // overlay with translucent background and cutout frame
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.isUserInteractionEnabled = false
        previewView.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: previewView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor)
        ])
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.35)
        overlayView.layer.addSublayer(frameLayer)
        
        // preview image view (hidden until capture)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.isHidden = true
        view.addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            previewImageView.topAnchor.constraint(equalTo: previewView.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor)
        ])
        
        // retake & save buttons (hidden until capture)
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.addTarget(self, action: #selector(didTapRetake), for: .touchUpInside)
        retakeButton.isHidden = true
        view.addSubview(retakeButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        saveButton.isHidden = true
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            retakeButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            saveButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor)
        ])
    }
    
    // MARK: - Overlay / Draft Frame
    private func updateOverlayPath() {
        // create a rounded rect in center as draft frame
        let w = previewView.bounds.width
        let h = previewView.bounds.height
        
        // Choose size and position for the frame (you can tweak)
        let frameWidth = min(w * 0.72, 400)
        let frameHeight = frameWidth // square; change if you prefer rectangle
        let frameX = (w - frameWidth) / 2
        let frameY = (h - frameHeight) / 2
        
        let path = UIBezierPath(rect: previewView.bounds)
        
        // For rounded rectangle frame:
        let roundedRect = UIBezierPath(roundedRect: CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight), cornerRadius: 20)
        path.append(roundedRect)
        path.usesEvenOddFillRule = true
        
        // Apply to overlay: fill the whole view with translucent black, but make cutout for frame
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        overlayView.layer.mask = mask
        
        // Draw visible stroke around the frame so user sees it clearly
        frameLayer.frame = overlayView.bounds
        frameLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let strokeLayer = CAShapeLayer()
        strokeLayer.path = roundedRect.cgPath
        strokeLayer.lineWidth = 3
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.shadowColor = UIColor.black.cgColor
        strokeLayer.shadowOpacity = 0.4
        strokeLayer.shadowOffset = CGSize(width: 0, height: 1)
        frameLayer.addSublayer(strokeLayer)
    }
    
    // MARK: - Camera configuration
    private func checkCameraAuthorizationAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            Task { await configureSession() }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        Task { await self.configureSession() }
                    } else {
                        self.showPermissionAlert()
                    }
                }
            }
        default:
            showPermissionAlert()
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please allow camera access in Settings to take selfies.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // Example using main actor to configure session
    private func configureSession() async {
        // Stop if running
        if session.isRunning { session.stopRunning() }
        
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        // Remove existing inputs
        if let current = videoDeviceInput {
            session.removeInput(current)
        }
        
        // Select camera
        guard let device = cameraDevice(for: currentCameraPosition) else {
            session.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                videoDeviceInput = input
            }
        } catch {
            print("Error creating device input: \(error)")
        }
        
        // Photo output
        if session.canAddOutput(photoOutput) == false {
            session.commitConfiguration()
            return
        }
        session.addOutput(photoOutput)
        photoOutput.isHighResolutionCaptureEnabled = true
        
        session.commitConfiguration()
        
        // Preview layer
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = previewView.bounds
            previewView.layer.insertSublayer(previewLayer, at: 0)
        }
        
        // For front camera mirror (user expects mirrored preview)
        previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
        previewLayer.connection?.isVideoMirrored = (currentCameraPosition == .front)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    private func cameraDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
        return discovery.devices.first
    }
    
    // MARK: - Actions
    @objc private func didTapCapture() {
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        settings.flashMode = .off // front flash isn't real; you may use screen flash technique
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func didTapSwitchCamera() {
        // toggle
        currentCameraPosition = (currentCameraPosition == .front) ? .back : .front
        Task { await configureSession() }
    }
    
    @objc private func didTapRetake() {
        previewImageView.isHidden = true
        retakeButton.isHidden = true
        saveButton.isHidden = true
        captureButton.isHidden = false
        switchCameraButton.isHidden = false
        session.startRunning()
    }
    
    @objc private func didTapSave() {
        guard let image = previewImageView.image else { return }
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Can't Save", message: "Photo library access required.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}


extension SelfieViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Photo capture error: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            print("Failed to convert photo data")
            return
        }
        
        // If using front camera, photo might be mirrored differently than preview
        // We prefer to present the image as user expects: mirrored like preview
        let finalImage: UIImage
        if currentCameraPosition == .front {
            finalImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        } else {
            finalImage = image
        }
        
        DispatchQueue.main.async {
            self.session.stopRunning()
            self.previewImageView.image = finalImage
            self.previewImageView.isHidden = false
            
            self.retakeButton.isHidden = false
            self.saveButton.isHidden = false
            self.captureButton.isHidden = true
            self.switchCameraButton.isHidden = true
        }
    }
}
