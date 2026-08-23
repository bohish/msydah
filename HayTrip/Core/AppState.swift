import Foundation
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    enum Step { case splash, onboarding, home, request, processing, flights, flightCompare, hotels, hotelCompare, building, itinerary }

    @Published var step: Step = .splash
    @Published var destination = ""
    @Published var dates = ""
    @Published var travelers = "٢ بالغين"
    @Published var budget = "7000"
    @Published var interests = ""
    @Published var selectedFlightID: String?
    @Published var selectedHotelID: String?
    @Published var compareFlightIDs: Set<String> = []
    @Published var compareHotelIDs: Set<String> = []

    var budgetValue: Int { Int(budget.filter(\.isNumber)) ?? 7000 }
    var selectedFlight: Flight? { MockData.flights.first { $0.id == selectedFlightID } }
    var selectedHotel: Hotel? { MockData.hotels.first { $0.id == selectedHotelID } }
    var totalCost: Int { (selectedFlight?.price ?? 0) + (selectedHotel?.totalPrice ?? 0) + 850 }
    var balance: Int { budgetValue - totalCost }

    func go(_ next: Step) { withAnimation(.easeInOut(duration: 0.28)) { step = next } }
}