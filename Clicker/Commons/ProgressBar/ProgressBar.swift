
import SwiftUI

struct ProgressBar: View {
    @State var progress: Float
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .frame(width: 55, height: 55, alignment: .center)
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: true)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.caption)
                .bold()
        }
    }
}
