import Foundation

struct Flight: Identifiable, Hashable { let id: String; let airline: String; let from: String; let to: String; let departure: String; let arrival: String; let duration: String; let stops: String; let price: Int; let baggage: String; let reason: String? }
struct Hotel: Identifiable, Hashable { let id: String; let name: String; let location: String; let rating: Double; let distance: String; let room: String; let cancellation: String; let priceNight: Int; let nights: Int; let reason: String?; var totalPrice: Int { priceNight * nights } }
struct Day: Identifiable { let id: String; let number: Int; let title: String; let items: [AgendaItem] }
struct AgendaItem: Identifiable { let id: String; let time: String; let title: String; let detail: String }

enum MockData {
    static let flights = [
        Flight(id:"f1", airline:"الخطوط السعودية", from:"الرياض", to:"طوكيو", departure:"10:00", arrival:"16:50", duration:"11س 50د", stops:"مباشر", price:3200, baggage:"2 × 23 كجم", reason:"الأفضل لك: رحلة مباشرة تختصر وقت السفر وتمنحك وصولًا أبكر.") ,
        Flight(id:"f2", airline:"طيران الإمارات", from:"الرياض", to:"طوكيو", departure:"08:00", arrival:"18:00", duration:"15س", stops:"توقف واحد", price:2450, baggage:"30 كجم", reason:nil),
        Flight(id:"f3", airline:"الخطوط القطرية", from:"الرياض", to:"طوكيو", departure:"11:30", arrival:"22:00", duration:"15س 30د", stops:"توقف واحد", price:2600, baggage:"25 كجم", reason:nil)
    ]
    static let hotels = [
        Hotel(id:"h1", name:"Aman Tokyo", location:"شينجوكو", rating:4.9, distance:"1.2 كم من المركز", room:"Deluxe Double", cancellation:"إلغاء مجاني", priceNight:800, nights:7, reason:"اختيار HayTrip: موقع ممتاز، تقييم مرتفع، وإلغاء مجاني ضمن الميزانية."),
        Hotel(id:"h2", name:"Park Hyatt Tokyo", location:"شيبويا", rating:4.8, distance:"3.5 كم من المركز", room:"Standard Suite", cancellation:"غير مسترد", priceNight:650, nights:7, reason:nil),
        Hotel(id:"h3", name:"The Ritz-Carlton", location:"روبونجي", rating:4.7, distance:"2.1 كم من المركز", room:"Deluxe King", cancellation:"إلغاء مجاني", priceNight:750, nights:7, reason:nil)
    ]
}