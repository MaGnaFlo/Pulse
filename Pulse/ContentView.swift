
import SwiftUI

func test(data: PulseData) -> String {
    return String(data.t0)
}

struct ContentView: View {
    
    var data = PulseData()
    @State var text = "0"
    
    var body: some View {
        VStack {
            Button {
                let t = Float(DispatchTime.now().uptimeNanoseconds)
                data.append(t: t)
                if data.time.count > 0 {
                    text = String(data.time[data.time.count-1])
                }
                print(data.time)
                
            } label: {
                Text("Pulse")
                    .frame(width: 200, height: 200)
                    .font(.system(size: 40, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(100)
            }
            
            Text(text)
                .font(.system(size: 50))
                .foregroundColor(Color(.label))
        }
    }
}

#Preview {
    ContentView()
}
