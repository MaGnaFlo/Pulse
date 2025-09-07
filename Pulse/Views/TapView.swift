

import SwiftUI

struct TapView: View {
    
    var data = PulseData()
    @State var text = "0"
    
    var body: some View {
        
        VStack {
            Button {
                let t = Double(DispatchTime.now().uptimeNanoseconds)
                data.append(t: t)
                data.compute_rate()
                print(data.time)
                
                if data.rates.count > 0 {
                    text = String(format: "%.1f", data.rates[data.rates.count-1])
                } else {
                    text = "0"
                }
                
                
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
    TapView()
        .preferredColorScheme(.dark)
}
