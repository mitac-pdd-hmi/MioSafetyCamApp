import SwiftUI

@main
struct MioSafetyCamApp: App {
    @State private var volume: CGFloat = 0.5
    
    var body: some Scene {
        WindowGroup {
            VolumeWidgetView(volume: $volume)
        }
        
    }
}
