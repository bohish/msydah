import SwiftUI

@main
struct HayTripApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environment(\.layoutDirection, .rightToLeft)
                .tint(HayTripTheme.richGreen)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        switch state.step {
        case .splash: SplashView()
        case .onboarding: OnboardingView()
        case .home: HomeView()
        case .request: TripRequestView()
        case .processing: ProcessingView()
        case .flights: FlightResultsView()
        case .flightCompare: FlightComparisonView()
        case .hotels: HotelResultsView()
        case .hotelCompare: HotelComparisonView()
        case .building: TripBuildingView()
        case .itinerary: ItineraryView()
        }
    }
}