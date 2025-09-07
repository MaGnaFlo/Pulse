
import SwiftUI

struct PPGView: View {
    
    @State private var isRecording = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // CameraView
                CameraView(isRecording: $isRecording)
                
                Spacer()
                
                Button {
                    isRecording.toggle()
                } label: {
                    Text(isRecording ? "Stop recording" : "Record")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                        .frame(width: 200, height: 50)
                        .background(isRecording ? .gray : .red)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    PPGView()
        .preferredColorScheme(.dark)
}
