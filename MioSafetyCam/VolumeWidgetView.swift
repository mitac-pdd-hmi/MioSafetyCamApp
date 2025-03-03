import SwiftUI

struct ContentView: View {
    @State private var volume: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            Color("color/gray/900")
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                HStack {
                    Spacer()
                    VolumeWidgetView(volume: $volume)
                        .frame(width: 83, height: 300)
                    Spacer()
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }
}

struct VolumeWidgetView: View {
    @Binding var volume: CGFloat
    
    private var speakerIconName: String {
        switch volume {
        case 0:
            return "speaker.slash.fill"
        case 0..<0.5:
            return "speaker.wave.1.fill"
        default:
            return "speaker.wave.2.fill"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let totalHeight = geo.size.height
            let whiteHeight = totalHeight * volume
            let whiteTopY = totalHeight - whiteHeight
            let iconCenterY = totalHeight - (20 + 16)
            let isIconCovered = whiteTopY < iconCenterY
            
            ZStack(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color("color/gray/700"))
                    
                    Rectangle()
                        .fill(Color("color/gray/200"))
                        .frame(height: whiteHeight)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    Image(systemName: speakerIconName)
                        .font(.system(size: 30)) // 30pt 字型大小
                        .foregroundColor(isIconCovered ? Color("color/gray/700") : Color("color/gray/200"))
                        .padding(.bottom, 20)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                )
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let locationY = value.location.y
                            let newVolume = (totalHeight - locationY) / totalHeight
                            volume = max(0, min(1, newVolume))
                        }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
