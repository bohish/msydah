# HayTrip iOS

Native SwiftUI iPhone-first prototype for HayTrip, a premium Saudi smart travel agency experience.

## Phase 1 scope
- iOS 17+
- SwiftUI / portrait-first iPhone UX
- Arabic RTL
- HayTrip H + travel-path visual language
- No generic AI sparkle/star iconography
- Agent-style trip request flow
- Manual search flow
- Mock flight and hotel discovery
- Normalized provider/currency/deep-link/stop/duration/room fields
- Mandatory Arabic recommendation explanation field
- Flight and hotel comparison
- "ساعدني أختار" decision support
- Shared budget calculation with remaining/overage state
- Dynamic 7-day itinerary derived from selections
- External-booking transition mock
- Native ShareLink
- My Trips / Favorites / Profile surfaces
- No backend, APIs, authentication, payments, or real booking yet

## Architecture direction
The provider layer is kept separate from the future AI/orchestrator layer. The future orchestrator should receive normalized provider-verified objects, rank and explain them, and never invent provider facts or prices.

## Run
Open `HayTrip.xcodeproj` in Xcode, choose an iPhone Simulator, and run.

Build execution has not been performed in this repository environment; the first real Xcode build should be treated as the authoritative compile check.