// SECTION 1: IMPORTS
import Foundation

// SECTION 2: MAINTABVIEWMODEL CLASS
class MainTabViewModel: ObservableObject {
    
    // This enum defines all the possible tabs in our app.
    enum Tab {
        case home
        case routines
        case progress
        case goals
        case settings
    }
    
    // This @Published property holds the currently selected tab.
    // When this changes, the TabView will switch to the new tab.
    @Published var selectedTab: Tab = .home
}
