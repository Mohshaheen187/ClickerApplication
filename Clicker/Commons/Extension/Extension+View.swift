

import Foundation
import SwiftUI
extension View {
    var maxedOut: some View {
        return Color.clear
            .overlay(self, alignment: .center)
    }
    func maxedOut(color: Color = Color.clear, alignment: Alignment = Alignment.leading) -> some View {
        return color
            .overlay(self, alignment: alignment)
    }
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
