import SwiftUI

@main
struct MioSafetyCamApp: App {
    @State private var volume: CGFloat = 0.5
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color("color/gray/900")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VolumeWidgetView(volume: $volume)
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                }
            }
        }
    }
}
