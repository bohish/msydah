import SwiftUI

private let istanbulPhoto = "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=1000&q=85"
private let parisPhoto = "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1000&q=85"
private let mountainPhoto = "https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1000&q=85"

struct BrandHomeView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                header
                hero
                agentCard
                manualSearch
                quickActions
                inspiration
            }
        }
        .background(HayTripTheme.offWhite.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) { BrandBottomBar(active: .home) }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 9) {
                Button { state.go(.profile) } label: { iconButton("person") }
                Button { } label: { iconButton("bell") }
            }
            Spacer()
            HayLogo(compact: true)
        }
        .padding(.horizontal, 22).padding(.top, 12).padding(.bottom, 16)
    }

    private func iconButton(_ name: String) -> some View -> some View {
        EmptyView()
    }

    private var hero: some View {
        ZStack(alignment: .topTrailing) {
            HayTripTheme.forest
            Circle().fill(HayTripTheme.darkGreen.opacity(0.75)).frame(width: 220, height: 220).offset(x: 95, y: -45)
            VStack(alignment: .trailing, spacing: 5) {
                Text("وين ودك تروح؟").font(HayTripTypography.hero(33)).foregroundStyle(.white)
                Text("خل HayTrip يخططها لك").font(HayTripTypography.body(16)).foregroundStyle(.white.opacity(0.72))
            }.padding(.top, 28).padding(.horizontal, 22)
        }
        .frame(height: 178)
        .clipped()
    }

    private var agentCard: some View {
        VStack(alignment: .trailing, spacing: 14) {
            HStack {
                VStack(alignment: .trailing, spacing: 2) { Text("HayTrip").font(HayTripTypography.section(18)).foregroundStyle(HayTripTheme.forest); Text("وكيل سفرك الذكي").font(HayTripTypography.caption(12)).foregroundStyle(HayTripTheme.darkGreen) }
                Spacer()
                BrandMark().frame(width: 48, height: 48)
            }
            TextField("اكتب طلب رحلتك بطريقتك... مثال: أبي أروح إسطنبول 5 أيام لشخصين وبميزانية 7,000 ريال", text: $query, axis: .vertical)
                .lineLimit(4).multilineTextAlignment(.trailing).font(HayTripTypography.body(15)).padding(16).frame(minHeight: 112, alignment: .topTrailing)
                .background(HayTripTheme.offWhite).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 18).stroke(HayTripTheme.line, lineWidth: 1))
            PrimaryButton(title: "ابدأ مع HayTrip") { state.searchMode = .agent; state.destination = query.isEmpty ? "إسطنبول" : query; state.go(.request) }
        }
        .padding(18).background(.white).clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)).shadow(color: .black.opacity(0.08), radius: 22, y: 12)
        .padding(.horizontal, 22).padding(.top, -22)
    }

    private var manualSearch: some View {
        Button { state.searchMode = .manual; state.go(.request) } label: { Text("أو ابحث يدويًا").font(HayTripTypography.medium(14)).foregroundStyle(HayTripTheme.muted).frame(maxWidth: .infinity).padding(.vertical, 15) }
    }

    private var quickActions: some View {
        HStack(spacing: 0) {
            action("الرحلات", "airplane", .flights)
            action("الفنادق", "building.2", .hotels)
        }.padding(.horizontal, 22).padding(.bottom, 28)
    }

    private func action(_ title: String, _ icon: String, _ step: AppState.Step) -> some View {
        Button { state.go(step) } label: { VStack(spacing: 7) { Image(systemName: icon).font(.system(size: 20)); Text(title).font(HayTripTypography.section(15)) }.foregroundStyle(HayTripTheme.forest).frame(maxWidth: .infinity) }
    }

    private var inspiration: some View {
        VStack(alignment: .trailing, spacing: 13) {
            Text("وجهات ملهمة").font(HayTripTypography.title(21)).foregroundStyle(HayTripTheme.forest)
            ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 12) { destination("إسطنبول", "الأكثر بحثًا", istanbulPhoto); destination("باريس", "رومانسية", parisPhoto); destination("الألب", "تجربة", mountainPhoto) } }
        }.padding(.horizontal, 22).padding(.bottom, 30)
    }

    private func destination(_ title: String, _ tag: String, _ url: String) -> some View {
        ZStack(alignment: .topTrailing) {
            DestinationPhoto(url: url, height: 172)
            LinearGradient(colors: [.clear, .black.opacity(0.58)], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .trailing) { Text(tag).font(HayTripTypography.caption(11)).padding(.horizontal, 10).padding(.vertical, 6).background(.white).clipShape(Capsule()); Spacer(); Text(title).font(HayTripTypography.title(19)).foregroundStyle(.white) }.padding(12)
        }.frame(width: 190, height: 172).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct BrandBottomBar: View {
    @EnvironmentObject var state: AppState
    let active: AppState.Step
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                item("الرئيسية", "house.fill", .home)
                item("رحلاتي", "bookmark", .trips)
                Spacer().frame(width: 66)
                item("المفضلة", "heart", .favorites)
                item("حسابي", "person", .profile)
            }
            .padding(.horizontal, 14).padding(.top, 12).padding(.bottom, 9).background(.ultraThinMaterial).background(.white.opacity(0.96)).overlay(alignment: .top) { Rectangle().fill(HayTripTheme.line).frame(height: 1) }
            Button { state.searchMode = .agent; state.go(.request) } label: { Circle().fill(HayTripTheme.green).frame(width: 58, height: 58).overlay(Image(systemName: "plus").font(.system(size: 25, weight: .semibold)).foregroundStyle(.white)).shadow(color: HayTripTheme.green.opacity(0.28), radius: 12, y: 6) }.offset(y: -29)
        }
    }
    private func item(_ title: String, _ icon: String, _ step: AppState.Step) -> some View {
        Button { state.go(step) } label: { VStack(spacing: 4) { Image(systemName: icon).font(.system(size: 17, weight: .semibold)); Text(title).font(HayTripTypography.caption(10)) }.foregroundStyle(active == step ? HayTripTheme.green : HayTripTheme.muted).frame(maxWidth: .infinity) }
    }
}