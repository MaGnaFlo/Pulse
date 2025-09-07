
import SwiftUI
struct CameraView: UIViewControllerRepresentable {
    
    @Binding var isRecording: Bool
    
    func makeUIViewController(context: Context) -> CameraVC {
        CameraVC(cameraDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isRecording {
            if !uiViewController.movieOutput.isRecording {
                uiViewController.startRecording()
            }
        } else {
            if uiViewController.movieOutput.isRecording {
                uiViewController.stopRecording()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraView: self)
    }
    
    final class Coordinator: NSObject, CameraVCDelegate {
        
        private let cameraView: CameraView
        
        init(cameraView: CameraView) {
            self.cameraView = cameraView
        }
        
        func didFind(barcode: String) {
        }
        
        func didSurface(error: CameraError) {
        }
    }
}
