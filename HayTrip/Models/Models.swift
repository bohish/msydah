import Foundation

struct Flight: Identifiable, Hashable {
    let id: String
    let provider: String
    let airline: String
    let from: String
    let to: String
    let departure: String
    let arrival: String
    let durationMin: Int
    let duration: String
    let stopCount: Int
    let stops: String
    let price: Int
    let currency: String
    let baggage: String
    let deepLink: String
    let reason: String
}

struct Hotel: Identifiable, Hashable {
    let id: String
    let provider: String
    let name: String
    let location: String
    let rating: Double
    let distance: String
    let room: String
    let cancellation: String
    let priceNight: Int
    let nights: Int
    let currency: String
    let deepLink: String
    let reason: String
    var totalPrice: Int { priceNight * nights }
}

struct Day: Identifiable {
    let id: String
    let number: Int
    let title: String
    let items: [AgendaItem]
}

struct AgendaItem: Identifiable {
    let id: String
    let time: String
    let title: String
    let detail: String
}

enum MockData {
    static let flights = [
        Flight(id: "f1", provider: "Mock Saudi", airline: "الخطوط السعودية", from: "الرياض", to: "طوكيو", departure: "10:00", arrival: "16:50", durationMin: 710, duration: "11س 50د", stopCount: 0, stops: "مباشر", price: 3200, currency: "SAR", baggage: "2 × 23 كجم", deepLink: "https://example.com/flight/f1", reason: "اختيار HayTrip: رحلة مباشرة تختصر وقت السفر وتوازن بين الراحة والسعر."),
        Flight(id: "f2", provider: "Mock Emirates", airline: "طيران الإمارات", from: "الرياض", to: "طوكيو", departure: "08:00", arrival: "18:00", durationMin: 900, duration: "15س", stopCount: 1, stops: "توقف واحد", price: 2450, currency: "SAR", baggage: "30 كجم", deepLink: "https://example.com/flight/f2", reason: "خيار اقتصادي قوي، لكنه يضيف توقفًا ووقت سفر أطول."),
        Flight(id: "f3", provider: "Mock Qatar", airline: "الخطوط القطرية", from: "الرياض", to: "طوكيو", departure: "11:30", arrival: "22:00", durationMin: 930, duration: "15س 30د", stopCount: 1, stops: "توقف واحد", price: 2600, currency: "SAR", baggage: "25 كجم", deepLink: "https://example.com/flight/f3", reason: "حل متوازن إذا كانت أولوية المغادرة المتأخرة أهم من تقليل مدة الرحلة.")
    ]

    static let hotels = [
        Hotel(id: "h1", provider: "Mock Booking", name: "Aman Tokyo", location: "شينجوكو", rating: 4.9, distance: "1.2 كم من المركز", room: "Deluxe Double", cancellation: "إلغاء مجاني", priceNight: 800, nights: 7, currency: "SAR", deepLink: "https://example.com/hotel/h1", reason: "اختيار HayTrip: موقع ممتاز، تقييم مرتفع، وإلغاء مجاني ضمن الميزانية."),
        Hotel(id: "h2", provider: "Mock Booking", name: "Park Hyatt Tokyo", location: "شيبويا", rating: 4.8, distance: "3.5 كم من المركز", room: "Standard Suite", cancellation: "غير مسترد", priceNight: 650, nights: 7, currency: "SAR", deepLink: "https://example.com/hotel/h2", reason: "قيمة سعرية قوية إذا كانت الأولوية لتقليل تكلفة الإقامة، مع تنازل عن مرونة الإلغاء."),
        Hotel(id: "h3", provider: "Mock Booking", name: "The Ritz-Carlton", location: "روبونجي", rating: 4.7, distance: "2.1 كم من المركز", room: "Deluxe King", cancellation: "إلغاء مجاني", priceNight: 750, nights: 7, currency: "SAR", deepLink: "https://example.com/hotel/h3", reason: "خيار فاخر متوازن لمن يهمه الإلغاء المجاني مع موقع مركزي.")
    ]
}