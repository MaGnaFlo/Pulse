
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TapView()) {
                    Text("Tap")
                        .font(.title2)
                        .fontWeight(.semibold)
                
                }
                NavigationLink(destination: PPGView()) {
                    Text("PPG")
                        .font(.title2)
                        .fontWeight(.semibold)
                
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Title")
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
