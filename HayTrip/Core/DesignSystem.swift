import SwiftUI

enum HayTripTheme {
    static let navy = Color(red: 0.035, green: 0.10, blue: 0.18)
    static let green = Color(red: 0.10, green: 0.28, blue: 0.21)
    static let ivory = Color(red: 0.975, green: 0.965, blue: 0.935)
    static let beige = Color(red: 0.90, green: 0.85, blue: 0.77)
    static let ink = Color(red: 0.12, green: 0.13, blue: 0.14)
    static let muted = Color(red: 0.43, green: 0.46, blue: 0.49)
}

extension View {
    func hayCard() -> some View {
        self.padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.055), radius: 16, y: 7)
    }
}

struct HayLogo: View {
    var light: Bool = false
    var body: some View {
        HStack(spacing: 9) {
            ZStack {
                Text("H")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(light ? .white : HayTripTheme.navy)
                Capsule()
                    .fill(HayTripTheme.green)
                    .frame(width: 28, height: 3)
                    .rotationEffect(.degrees(-25))
                    .offset(x: 7, y: -5)
                Image(systemName: "airplane")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(HayTripTheme.green)
                    .rotationEffect(.degrees(-18))
                    .offset(x: 13, y: -9)
            }
            Text("HayTrip")
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundStyle(light ? .white : HayTripTheme.navy)
        }
        .accessibilityLabel("HayTrip")
    }
}

struct PrimaryButton: View {
    let title: String
    var disabled = false
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(disabled ? HayTripTheme.muted : HayTripTheme.navy)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }.disabled(disabled)
    }
}