import SwiftUI

@main
@MainActor
struct HayTripApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            HayTripRootView()
                .environmentObject(appState)
                .environment(\.layoutDirection, .rightToLeft)
                .tint(HayTripTheme.green)
        }
    }
}

@MainActor
struct HayTripRootView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ZStack {
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
            case .booking: BookingNoticeView()
            case .trips: TripsView()
            case .favorites: FavoritesView()
            case .profile: ProfileView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HayTripTheme.ivory.ignoresSafeArea())
    }
}