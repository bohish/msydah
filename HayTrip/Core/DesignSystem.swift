import SwiftUI

enum HayTripTheme {
    static let forest = Color(red: 0x0B/255.0, green: 0x1D/255.0, blue: 0x1B/255.0)
    static let darkGreen = Color(red: 0x12/255.0, green: 0x5E/255.0, blue: 0x4B/255.0)
    static let green = Color(red: 0x22/255.0, green: 0xC5/255.0, blue: 0x5E/255.0)
    static let offWhite = Color(red: 0xF5/255.0, green: 0xF7/255.0, blue: 0xFA/255.0)
    static let line = Color(red: 0xE6/255.0, green: 0xE9/255.0, blue: 0xED/255.0)
    static let ink = Color(red: 0.055, green: 0.075, blue: 0.09)
    static let muted = Color(red: 0.40, green: 0.44, blue: 0.47)
    static let white = Color.white
    static let navy = forest
    static let ivory = offWhite
    static let beige = line
}

enum HayTripTypography {
    static func hero(_ size: CGFloat = 34) -> Font { .system(size: size, weight: .bold) }
    static func title(_ size: CGFloat = 24) -> Font { .system(size: size, weight: .bold) }
    static func section(_ size: CGFloat = 18) -> Font { .system(size: size, weight: .bold) }
    static func body(_ size: CGFloat = 15) -> Font { .system(size: size, weight: .regular) }
    static func medium(_ size: CGFloat = 14) -> Font { .system(size: size, weight: .medium) }
    static func caption(_ size: CGFloat = 12) -> Font { .system(size: size, weight: .medium) }
}

struct HayLogo: View {
    var light = false
    var compact = false
    var body: some View {
        HStack(spacing: compact ? 6 : 8) {
            ZStack {
                Text("H").font(.system(size: compact ? 27 : 38, weight: .black, design: .rounded)).foregroundStyle(light ? .white : HayTripTheme.forest)
                Capsule().fill(HayTripTheme.green).frame(width: compact ? 23 : 31, height: compact ? 3 : 4).rotationEffect(.degrees(-24)).offset(x: compact ? 5 : 7, y: compact ? -4 : -5)
                Image(systemName: "airplane").font(.system(size: compact ? 9 : 12, weight: .bold)).foregroundStyle(HayTripTheme.green).rotationEffect(.degrees(-18)).offset(x: compact ? 11 : 15, y: compact ? -7 : -10)
            }
            Text("HayTrip").font(.system(size: compact ? 17 : 22, weight: .bold, design: .rounded)).foregroundStyle(light ? .white : HayTripTheme.forest)
        }
        .accessibilityLabel("HayTrip")
    }
}

struct BrandMark: View {
    var body: some View { ZStack { RoundedRectangle(cornerRadius: 18, style: .continuous).fill(HayTripTheme.forest); HayLogo(light: true, compact: true).scaleEffect(1.15) }.frame(width: 62, height: 62) }
}

struct PrimaryButton: View {
    let title: String
    var disabled = false
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) { Text(title).font(HayTripTypography.section(16)); Image(systemName: "arrow.left").font(.system(size: 13, weight: .bold)) }
                .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(disabled ? HayTripTheme.line : HayTripTheme.green)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: disabled ? .clear : HayTripTheme.green.opacity(0.22), radius: 14, y: 8)
        }.disabled(disabled)
    }
}

struct BrandCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View { content.padding(18).background(HayTripTheme.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 22).stroke(HayTripTheme.line, lineWidth: 1)).shadow(color: .black.opacity(0.045), radius: 16, y: 8) }
}

struct Pill: View {
    let title: String
    var selected = false
    var body: some View { Text(title).font(HayTripTypography.medium(13)).foregroundStyle(selected ? .white : HayTripTheme.forest).padding(.horizontal, 15).padding(.vertical, 9).background(selected ? HayTripTheme.darkGreen : .white).overlay(Capsule().stroke(selected ? .clear : HayTripTheme.line, lineWidth: 1)).clipShape(Capsule()) }
}

struct DestinationPhoto: View {
    let url: String
    let height: CGFloat
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if case .success(let image) = phase { image.resizable().scaledToFill() }
            else { LinearGradient(colors: [HayTripTheme.forest, HayTripTheme.darkGreen], startPoint: .topLeading, endPoint: .bottomTrailing).overlay(Image(systemName: "airplane").font(.system(size: 28)).foregroundStyle(.white.opacity(0.7))) }
        }.frame(height: height).clipped()
    }
}

extension View {
    func hayCard() -> some View { self.padding(18).background(HayTripTheme.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 22).stroke(HayTripTheme.line, lineWidth: 1)).shadow(color: .black.opacity(0.045), radius: 16, y: 8) }
}