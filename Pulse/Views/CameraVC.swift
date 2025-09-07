
import Foundation
import AVFoundation
import UIKit
import Photos

enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}

protocol CameraVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class CameraVC: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var movieOutput = AVCaptureMovieFileOutput()
    weak var cameraDelegate: CameraVCDelegate?
    
    init(cameraDelegate: CameraVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.cameraDelegate = cameraDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            cameraDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        
        // Camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            cameraDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            cameraDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            cameraDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // lock device settings
        do {
            try videoCaptureDevice.lockForConfiguration()
            
            // continuous light
            if videoCaptureDevice.hasTorch {
                try? videoCaptureDevice.setTorchModeOn(level: 1.0)
            }
            
            // Fix frame rate (example: 30 fps)
            if let range = videoCaptureDevice.activeFormat.videoSupportedFrameRateRanges.first,
               range.minFrameRate <= 30, range.maxFrameRate >= 30 {
                videoCaptureDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 30)
                videoCaptureDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 30)
            }
            
            // Lock exposure
            if videoCaptureDevice.isExposureModeSupported(.locked) {
                videoCaptureDevice.exposureMode = .locked
            }
            
            // Lock white balance
            if videoCaptureDevice.isWhiteBalanceModeSupported(.locked) {
                videoCaptureDevice.whiteBalanceMode = .locked
            }
            
            // exposure
            let minISO = videoCaptureDevice.activeFormat.minISO
            let maxISO = videoCaptureDevice.activeFormat.maxISO
            let targetISO = (minISO + maxISO) / 2.0
            let targetDuration = CMTimeMake(value: 1, timescale: 60)
            
            videoCaptureDevice.setExposureModeCustom(duration: targetDuration, iso: targetISO, completionHandler: nil
            )
            
            // Lock focus (usually close-up)
            if videoCaptureDevice.isFocusModeSupported(.locked) {
                videoCaptureDevice.focusMode = .locked
            }
            
            videoCaptureDevice.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
        }
        
        // movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    // recording controls
    func startRecording() {
        if let device = AVCaptureDevice.default(for: .video),
           device.hasTorch, device.torchMode == .off {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .on
                    device.unlockForConfiguration()
                } catch {
                    print("Torch could not be used")
                }
            }
        
        let outputPath = NSTemporaryDirectory() + UUID().uuidString + ".mov"
        let outputFileURL = URL(fileURLWithPath: outputPath)
        movieOutput.startRecording(to: outputFileURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        }
        
        if let device = AVCaptureDevice.default(for: .video),
           device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be turned off")
            }
        }
    }
}

extension CameraVC {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        guard error == nil else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                })
            }
        }
    }
}

