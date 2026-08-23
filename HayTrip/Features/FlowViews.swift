import SwiftUI

private struct SectionTitle: View {
    let title: String
    let subtitle: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 30, weight: .bold)).foregroundStyle(HayTripTheme.navy)
            if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(HayTripTheme.muted) }
        }
    }
}

private struct Pill: View {
    let title: String
    let selected: Bool
    var body: some View {
        Text(title).font(.system(size: 14, weight: .medium))
            .foregroundStyle(selected ? .white : HayTripTheme.navy)
            .padding(.horizontal, 14).padding(.vertical, 9)
            .background(selected ? HayTripTheme.navy : HayTripTheme.beige.opacity(0.5))
            .clipShape(Capsule())
    }
}

struct SplashView: View {
    @EnvironmentObject var state: AppState
    @State private var show = false
    var body: some View {
        ZStack { HayTripTheme.navy.ignoresSafeArea(); VStack(spacing: 14) { HayLogo(light: true).scaleEffect(show ? 1 : 0.88).opacity(show ? 1 : 0); Text("وكالة سفرك الذكية").foregroundStyle(.white.opacity(0.72)).font(.subheadline) } }
            .task { withAnimation(.easeOut(duration: 0.8)) { show = true }; try? await Task.sleep(for: .seconds(1.7)); state.go(.onboarding) }
    }
}

struct OnboardingView: View {
    @EnvironmentObject var state: AppState
    @State private var page = 0
    private let titles = ["خطط لرحلتك بطريقتك", "نساعدك تختار الأفضل", "ونجهز لك الرحلة كاملة"]
    private let subtitles = ["احكِ لنا عن الرحلة بالطريقة اللي تناسبك.", "نوازن لك بين السعر والوقت والراحة، ونشرح لك السبب.", "من أول اختيار إلى جدول الأيام، كل شيء مرتب في مكان واحد."]
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack { Circle().fill(HayTripTheme.beige.opacity(0.55)).frame(width: 250, height: 250); HayLogo().scaleEffect(1.25) }
            Text(titles[page]).font(.system(size: 30, weight: .bold)).multilineTextAlignment(.center).foregroundStyle(HayTripTheme.navy)
            Text(subtitles[page]).font(.body).multilineTextAlignment(.center).foregroundStyle(HayTripTheme.muted).padding(.horizontal, 30)
            Spacer()
            HStack(spacing: 7) { ForEach(0..<3, id: \.self) { i in Capsule().fill(i == page ? HayTripTheme.navy : HayTripTheme.beige).frame(width: i == page ? 24 : 7, height: 7) } }
            PrimaryButton(title: page < 2 ? "التالي" : "ابدأ رحلتك") { if page < 2 { withAnimation { page += 1 } } else { state.go(.home) } }.padding(.horizontal, 24).padding(.bottom, 28)
        }.padding(.top, 30).background(HayTripTheme.ivory.ignoresSafeArea())
    }
}

struct HomeView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""
    var body: some View {
        TabView {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack { HayLogo(); Spacer(); Button { state.go(.profile) } label: { Image(systemName: "person.crop.circle").font(.title2).foregroundStyle(HayTripTheme.navy) } }
                    SectionTitle(title: "إلى أين وجهتك القادمة؟", subtitle: "وكالة سفرك الذكية تصمم لك الرحلة، مو مجرد حجز.")
                    VStack(alignment: .leading, spacing: 14) {
                        TextField("مثال: أبي رحلة لليابان 7 أيام بميزانية 7,000 ريال...", text: $query, axis: .vertical).lineLimit(4).padding(16).frame(minHeight: 118, alignment: .top).background(.white).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        PrimaryButton(title: "خطط رحلتي") { state.searchMode = .agent; state.destination = query.isEmpty ? "طوكيو، اليابان" : query; state.go(.request) }
                        Button("أبحث بنفسي") { state.searchMode = .manual; state.go(.request) }.font(.subheadline.weight(.semibold)).foregroundStyle(HayTripTheme.green).frame(maxWidth: .infinity)
                    }.hayCard()
                    Text("أساليب رحلة شائعة").font(.title3.bold()).foregroundStyle(HayTripTheme.navy)
                    ScrollView(.horizontal, showsIndicators: false) { HStack { ForEach(["رحلة عائلية", "شهر عسل", "مغامرة", "استرخاء", "اقتصادية"], id: \.self) { Pill(title: $0, selected: false) } } }
                    VStack(alignment: .leading, spacing: 10) { Text("كيف يعمل HayTrip؟").font(.title3.bold()); Text("تكتب طلبك → نفهم تفضيلاتك → نعرض الخيارات الموثقة → نساعدك بالمقارنة → نبني لك الخطة.").font(.subheadline).foregroundStyle(HayTripTheme.muted) }.hayCard()
                }.padding(24)
            }.background(HayTripTheme.ivory.ignoresSafeArea()).tabItem { Label("الرئيسية", systemImage: "house") }
            TripsView().tabItem { Label("رحلاتي", systemImage: "airplane") }
            FavoritesView().tabItem { Label("المفضلة", systemImage: "heart") }
            ProfileView().tabItem { Label("حسابي", systemImage: "person") }
        }.tint(HayTripTheme.green)
    }
}

struct TripsView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(title: "رحلاتي", subtitle: "خططك المحفوظة تظهر هنا.")
            if state.savedTrip { VStack(alignment: .leading, spacing: 10) { Text(state.destination.isEmpty ? "رحلة طوكيو" : state.destination).font(.headline); Text("خطة مكتملة • \(state.totalCost) ر.س").foregroundStyle(HayTripTheme.muted); PrimaryButton(title: "فتح الخطة") { state.go(.itinerary) } }.hayCard() }
            else { ContentUnavailableView("ما عندك رحلات محفوظة", systemImage: "airplane", description: Text("ابدأ رحلة جديدة وخل HayTrip يرتبها لك.")); PrimaryButton(title: "ابدأ رحلة") { state.searchMode = .agent; state.go(.request) } }
            Spacer()
        }.padding(24).background(HayTripTheme.ivory.ignoresSafeArea())
    }
}

struct FavoritesView: View {
    var body: some View { VStack(alignment: .leading, spacing: 20) { SectionTitle(title: "المفضلة", subtitle: "احفظ الخيارات التي تبغى ترجع لها."); ContentUnavailableView("لا توجد مفضلات", systemImage: "heart", description: Text("أثناء المقارنة تقدر ترجع للخيارات المفضلة لاحقًا.")); Spacer() }.padding(24).background(HayTripTheme.ivory.ignoresSafeArea()) }
}

struct ProfileView: View {
    @EnvironmentObject var state: AppState
    var body: some View { List { Section("حسابك") { Label("هشام", systemImage: "person"); Label("تفضيلات السفر", systemImage: "slider.horizontal.3") }; Section("التطبيق") { Label("الإشعارات", systemImage: "bell"); Label("الإعدادات", systemImage: "gear") }; Section { Button("بدء رحلة جديدة") { state.searchMode = .agent; state.go(.request) } } }.scrollContentBackground(.hidden).background(HayTripTheme.ivory.ignoresSafeArea()) }
}

struct TripRequestView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 20) {
            Button("رجوع") { state.go(.home) }.foregroundStyle(HayTripTheme.green)
            SectionTitle(title: state.searchMode == .agent ? "خلنا نفهم رحلتك" : "البحث اليدوي", subtitle: state.searchMode == .agent ? "أعطنا التفاصيل اللي تعرفها والباقي علينا." : "حدد طلبك بنفسك ثم راجع النتائج وقارنها.")
            FormField(title: "الوجهة", placeholder: "طوكيو، اليابان", text: $state.destination)
            FormField(title: "التاريخ", placeholder: "١ نوفمبر – ٧ نوفمبر", text: $state.dates)
            FormField(title: "المسافرون", placeholder: "٢ بالغين", text: $state.travelers)
            FormField(title: "الميزانية بالريال", placeholder: "7000", text: $state.budget, number: true)
            FormField(title: "اهتماماتك", placeholder: "تسوق، مطاعم، ثقافة...", text: $state.interests)
            PrimaryButton(title: state.searchMode == .agent ? "ابدأ التخطيط" : "ابحث عن الخيارات") { state.go(.processing) }
        }.padding(24) }.background(HayTripTheme.ivory.ignoresSafeArea())
    }
}

private struct FormField: View {
    let title: String; let placeholder: String; @Binding var text: String; var number = false
    var body: some View { VStack(alignment: .leading, spacing: 7) { Text(title).font(.caption.weight(.semibold)).foregroundStyle(HayTripTheme.muted); TextField(placeholder, text: $text).keyboardType(number ? .numberPad : .default).multilineTextAlignment(.trailing).padding(15).background(.white).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) } }
}

struct ProcessingView: View {
    @EnvironmentObject var state: AppState
    @State private var index = 0
    let steps = ["نفهم طلبك", "نبحث عن الخيارات المناسبة", "نقارن الرحلات والفنادق", "نجهز لك التوصيات"]
    var body: some View { VStack(spacing: 25) { ZStack { Circle().stroke(HayTripTheme.beige, lineWidth: 9).frame(width: 92, height: 92); HayLogo().scaleEffect(0.72) }; Text(steps[index]).font(.title2.bold()).foregroundStyle(HayTripTheme.navy); ProgressView(value: Double(index + 1), total: Double(steps.count)).tint(HayTripTheme.green).frame(width: 220); Text("نستخدم النتائج الموثقة فقط داخل التجربة.").font(.caption).foregroundStyle(HayTripTheme.muted) }.frame(maxWidth: .infinity, maxHeight: .infinity).background(HayTripTheme.ivory.ignoresSafeArea()).task { for i in 1..<steps.count { try? await Task.sleep(for: .seconds(0.75)); withAnimation { index = i } }; try? await Task.sleep(for: .seconds(0.55)); state.go(.flights) } }
}

struct FlightResultsView: View {
    @EnvironmentObject var state: AppState
    @State private var sort = 0
    var flights: [Flight] { switch sort { case 1: return MockData.flights.sorted { $0.price < $1.price }; case 2: return MockData.flights.sorted { $0.durationMin < $1.durationMin }; default: return MockData.flights } }
    var body: some View {
        VStack(alignment: .leading) {
            SectionTitle(title: "رحلات إلى طوكيو", subtitle: "اختر رحلتين للمقارنة، أو خل HayTrip يساعدك.").padding(.horizontal, 24).padding(.top, 20)
            ScrollView(.horizontal, showsIndicators: false) { HStack { Pill(title: "الموصى", selected: sort == 0).onTapGesture { sort = 0 }; Pill(title: "الأرخص", selected: sort == 1).onTapGesture { sort = 1 }; Pill(title: "الأسرع", selected: sort == 2).onTapGesture { sort = 2 } }.padding(.horizontal, 24) }
            ScrollView { VStack(spacing: 14) { ForEach(flights) { f in FlightCard(flight: f, selected: state.compareFlightIDs.contains(f.id)) { toggleFlight(f.id) } } }.padding(24) }
            HStack(spacing: 10) { PrimaryButton(title: "قارن (\(state.compareFlightIDs.count))", disabled: state.compareFlightIDs.count != 2) { state.go(.flightCompare) }; Button("ساعدني أختار") { if let best = MockData.flights.first(where: { $0.reason != nil }) { state.compareFlightIDs = [best.id, MockData.flights.first(where: { $0.id != best.id })?.id ?? best.id].compactMap { $0 }.reduce(into: Set<String>()) { $0.insert($1) } }; state.go(.flightCompare) }.buttonStyle(.borderedProminent).tint(HayTripTheme.green) }.padding(24)
        }.background(HayTripTheme.ivory.ignoresSafeArea())
    }
    private func toggleFlight(_ id: String) { if state.compareFlightIDs.contains(id) { state.compareFlightIDs.remove(id) } else if state.compareFlightIDs.count < 2 { state.compareFlightIDs.insert(id) } }
}

struct FlightCard: View {
    let flight: Flight; let selected: Bool; let action: () -> Void
    var body: some View { Button(action: action) { VStack(alignment: .leading, spacing: 14) { HStack { Text(flight.airline).font(.headline); Spacer(); Text("\(flight.price) ر.س").font(.title3.bold()) }; HStack { VStack(alignment: .leading) { Text(flight.departure); Text(flight.from).font(.caption).foregroundStyle(HayTripTheme.muted) }; Spacer(); VStack { Text(flight.duration).font(.caption); Rectangle().fill(HayTripTheme.beige).frame(height: 2).frame(width: 65); Text(flight.stops).font(.caption).foregroundStyle(HayTripTheme.muted) }; Spacer(); VStack(alignment: .trailing) { Text(flight.arrival); Text(flight.to).font(.caption).foregroundStyle(HayTripTheme.muted) } }; HStack { Label(flight.baggage, systemImage: "bag").font(.caption); Spacer(); Image(systemName: selected ? "checkmark.circle.fill" : "circle").foregroundStyle(selected ? HayTripTheme.green : HayTripTheme.muted) }; if let reason = flight.reason { Text(reason).font(.caption).foregroundStyle(HayTripTheme.green) } }.foregroundStyle(HayTripTheme.ink).hayCard().overlay(RoundedRectangle(cornerRadius: 22).stroke(selected ? HayTripTheme.green : .clear, lineWidth: 2)) }.buttonStyle(.plain) }
}

struct FlightComparisonView: View {
    @EnvironmentObject var state: AppState
    var flights: [Flight] { MockData.flights.filter { state.compareFlightIDs.contains($0.id) } }
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 18) { SectionTitle(title: "قارن واختار", subtitle: "ما نختار الأرخص تلقائيًا؛ نوضح لك المفاضلة."); ForEach(flights) { f in VStack(alignment: .leading, spacing: 13) { HStack { Text(f.airline).font(.headline); Spacer(); Text("\(f.price) ر.س").font(.title3.bold()) }; HStack { Stat(title: "المدة", value: f.duration); Stat(title: "التوقف", value: f.stops); Stat(title: "الحقائب", value: f.baggage) }; Text(f.reason ?? "خيار جيد إذا كانت الأولوية للسعر.").font(.subheadline).foregroundStyle(HayTripTheme.muted); PrimaryButton(title: "اختيار الرحلة") { state.selectedFlightID = f.id; state.go(.hotels) } }.hayCard() }; VStack(alignment: .leading, spacing: 8) { Text("ساعدني أختار").font(.title3.bold()); Text("الأرخص ليس بالضرورة الأفضل. نقارن السعر مع وقت السفر والتوقف والراحة قبل التوصية.").foregroundStyle(HayTripTheme.green) }.hayCard() }.padding(24) }.background(HayTripTheme.ivory.ignoresSafeArea()) }
}

struct HotelResultsView: View {
    @EnvironmentObject var state: AppState
    var body: some View { VStack(alignment: .leading) { SectionTitle(title: "فنادق مقترحة", subtitle: "اختر فندقين للمقارنة.").padding(.horizontal, 24).padding(.top, 20); ScrollView { VStack(spacing: 14) { ForEach(MockData.hotels) { h in HotelCard(hotel: h, selected: state.compareHotelIDs.contains(h.id)) { toggleHotel(h.id) } } }.padding(24) }; HStack(spacing: 10) { PrimaryButton(title: "قارن (\(state.compareHotelIDs.count))", disabled: state.compareHotelIDs.count != 2) { state.go(.hotelCompare) }; Button("ساعدني أختار") { if let best = MockData.hotels.first(where: { $0.reason != nil }) { let second = MockData.hotels.first(where: { $0.id != best.id }); state.compareHotelIDs = [best.id, second?.id].compactMap { $0 }.reduce(into: Set<String>()) { $0.insert($1) } }; state.go(.hotelCompare) }.buttonStyle(.borderedProminent).tint(HayTripTheme.green) }.padding(24) }.background(HayTripTheme.ivory.ignoresSafeArea()) }
    private func toggleHotel(_ id: String) { if state.compareHotelIDs.contains(id) { state.compareHotelIDs.remove(id) } else if state.compareHotelIDs.count < 2 { state.compareHotelIDs.insert(id) } }
}

struct HotelCard: View {
    let hotel: Hotel; let selected: Bool; let action: () -> Void
    var body: some View { Button(action: action) { VStack(alignment: .leading, spacing: 12) { RoundedRectangle(cornerRadius: 16).fill(HayTripTheme.beige).frame(height: 128).overlay(HayLogo().scaleEffect(0.7)); HStack { Text(hotel.name).font(.headline); Spacer(); Label(String(format: "%.1f", hotel.rating), systemImage: "star.fill").foregroundStyle(HayTripTheme.green) }; Text("\(hotel.location) • \(hotel.distance)").font(.caption).foregroundStyle(HayTripTheme.muted); HStack { Text("\(hotel.totalPrice) ر.س").font(.title3.bold()); Text("لـ \(hotel.nights) ليالي").font(.caption).foregroundStyle(HayTripTheme.muted); Spacer(); Image(systemName: selected ? "checkmark.circle.fill" : "circle").foregroundStyle(selected ? HayTripTheme.green : HayTripTheme.muted) }; Text("\(hotel.room) • \(hotel.cancellation)").font(.caption).foregroundStyle(HayTripTheme.muted); if let reason = hotel.reason { Text(reason).font(.caption).foregroundStyle(HayTripTheme.green) } }.foregroundStyle(HayTripTheme.ink).hayCard().overlay(RoundedRectangle(cornerRadius: 22).stroke(selected ? HayTripTheme.green : .clear, lineWidth: 2)) }.buttonStyle(.plain) }
}

struct HotelComparisonView: View {
    @EnvironmentObject var state: AppState
    var hotels: [Hotel] { MockData.hotels.filter { state.compareHotelIDs.contains($0.id) } }
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 18) { SectionTitle(title: "قارن واختار", subtitle: "نوازن السعر والموقع والتقييم وشروط الحجز."); ForEach(hotels) { h in VStack(alignment: .leading, spacing: 13) { HStack { Text(h.name).font(.headline); Spacer(); Text("\(h.totalPrice) ر.س").font(.title3.bold()) }; HStack { Stat(title: "التقييم", value: "\(h.rating)"); Stat(title: "الموقع", value: h.distance); Stat(title: "الإلغاء", value: h.cancellation) }; Text(h.reason ?? "خيار مناسب إذا كانت الأولوية للسعر.").font(.subheadline).foregroundStyle(HayTripTheme.muted); PrimaryButton(title: "اختيار الفندق") { state.selectedHotelID = h.id; state.go(.building) } }.hayCard() }; VStack(alignment: .leading, spacing: 8) { Text("ساعدني أختار").font(.title3.bold()); Text("الأغلى ليس بالضرورة الأفضل؛ نراعي موقع الفندق وتقييمه وشروطه وميزانيتك.").foregroundStyle(HayTripTheme.green) }.hayCard() }.padding(24) }.background(HayTripTheme.ivory.ignoresSafeArea()) }
}

private struct Stat: View {
    let title: String; let value: String
    var body: some View { VStack(alignment: .leading, spacing: 4) { Text(title).font(.caption).foregroundStyle(HayTripTheme.muted); Text(value).font(.subheadline.bold()) }.frame(maxWidth: .infinity, alignment: .leading) }
}

struct TripBuildingView: View {
    @EnvironmentObject var state: AppState
    var body: some View { VStack(spacing: 24) { HayLogo(); Text("نجهز لك خطة رحلتك").font(.title.bold()); Text("نرتب الأيام حول الرحلة والفندق واختياراتك.").foregroundStyle(HayTripTheme.muted); ProgressView().tint(HayTripTheme.green) }.frame(maxWidth: .infinity, maxHeight: .infinity).background(HayTripTheme.ivory.ignoresSafeArea()).task { try? await Task.sleep(for: .seconds(1.5)); state.go(.itinerary) } }
}

struct ItineraryView: View {
    @EnvironmentObject var state: AppState
    var days: [Day] {
        let arrival = state.selectedFlight?.arrival ?? "16:50"; let hotel = state.selectedHotel?.name ?? "الفندق"
        return (1...7).map { n in
            if n == 1 { return Day(id: "d1", number: 1, title: "الوصول والاستقرار", items: [AgendaItem(id: "d1a1", time: arrival, title: "الوصول إلى طوكيو", detail: "عبر \(state.selectedFlight?.airline ?? "رحلتك")"), AgendaItem(id: "d1a2", time: "18:30", title: "الانتقال وتسجيل الدخول", detail: hotel), AgendaItem(id: "d1a3", time: "20:30", title: "عشاء قريب", detail: "اقتراح مناسب بعد السفر")]) }
            return Day(id: "d\(n)", number: n, title: n == 7 ? "اليوم الأخير والعودة" : "استكشاف الوجهة", items: [AgendaItem(id: "d\(n)a1", time: "09:00", title: "الإفطار", detail: hotel), AgendaItem(id: "d\(n)a2", time: "11:00", title: "تجربة اليوم", detail: state.interests.isEmpty ? "تجربة محلية مختارة حسب رحلتك" : state.interests), AgendaItem(id: "d\(n)a3", time: "19:30", title: "عشاء ومساء", detail: "اختيار HayTrip")])
        }
    }
    var shareText: String { "رحلتي مع HayTrip\n\(state.destination)\n\(state.totalCost) ر.س" }
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 20) { HStack { HayLogo(); Spacer(); Button { state.savedTrip = true } label: { Image(systemName: state.savedTrip ? "bookmark.fill" : "bookmark").font(.title3).foregroundStyle(HayTripTheme.green) } }; SectionTitle(title: "خطة رحلتك", subtitle: "\(state.destination.isEmpty ? "طوكيو، اليابان" : state.destination) • \(state.travelers)"); VStack(spacing: 12) { HStack { Text("إجمالي التكلفة"); Spacer(); Text("\(state.totalCost) ر.س").font(.title2.bold()) }; HStack { Text(state.balance >= 0 ? "الميزانية المتبقية" : "تجاوز الميزانية"); Spacer(); Text("\(abs(state.balance)) ر.س").fontWeight(.bold).foregroundStyle(state.balance >= 0 ? HayTripTheme.green : .red) }; Text("يشمل الطيران + الفندق + تقدير الأنشطة التجريبي.").font(.caption).foregroundStyle(HayTripTheme.muted).frame(maxWidth: .infinity, alignment: .leading) }.hayCard(); Text("جدول الرحلة").font(.title2.bold()); ForEach(days) { day in VStack(alignment: .leading, spacing: 14) { Text("اليوم \(day.number): \(day.title)").font(.headline); ForEach(day.items) { item in HStack(alignment: .top, spacing: 12) { Text(item.time).font(.caption.monospaced()).frame(width: 50, alignment: .leading).foregroundStyle(HayTripTheme.muted); Circle().fill(HayTripTheme.green).frame(width: 8, height: 8).padding(.top, 5); VStack(alignment: .leading, spacing: 3) { Text(item.title).font(.subheadline.weight(.semibold)); Text(item.detail).font(.caption).foregroundStyle(HayTripTheme.muted) }; Spacer() } } }.hayCard() }; Text("الحجز").font(.title2.bold()); PrimaryButton(title: "متابعة إلى موقع الحجز") { state.go(.booking) }; ShareLink(item: shareText) { Text("مشاركة الخطة").font(.headline).foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 16).background(HayTripTheme.green).clipShape(RoundedRectangle(cornerRadius: 16)) }.padding(.bottom, 24) }.padding(24) }.background(HayTripTheme.ivory.ignoresSafeArea()) }
}

struct BookingNoticeView: View {
    @EnvironmentObject var state: AppState
    var body: some View { VStack(spacing: 20) { HayLogo(); Text("ستنتقل الآن إلى موقع الحجز").font(.title2.bold()).multilineTextAlignment(.center); Text("HayTrip لا ينفذ الدفع داخل التطبيق في هذه المرحلة. هذه شاشة محاكاة لرحلة الحجز الخارجية.").multilineTextAlignment(.center).foregroundStyle(HayTripTheme.muted); PrimaryButton(title: "متابعة") { state.go(.itinerary) }; Button("العودة للخطة") { state.go(.itinerary) }.foregroundStyle(HayTripTheme.green) }.padding(28).frame(maxWidth: .infinity, maxHeight: .infinity).background(HayTripTheme.ivory.ignoresSafeArea()) }
}
