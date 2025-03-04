import SwiftUI

struct SpeedAlertWidgetView: View {
    // 速度與速限、距離相關狀態
    @State private var speed: Int = 120       // 當前速度
    @State private var speedLimit: Int = 110    // 速限
    @State private var distance: CGFloat = 250  // 當前距離
    @State private var distanceToSpeedCamera: CGFloat = 500 // 與 speed camera 的距離
    
    @StateObject private var viewModel = SpeedAlertViewModel()
    
    var overSpeed: Bool { speed > speedLimit }
    
    var dynamicNoCameraLineWidth: CGFloat {
        let speedToFloat = CGFloat(speed)
        let finalWidth = speedToFloat * 0.5
        return finalWidth
    }
    
    var body: some View {
        ZStack {
            Color("color/gray/800")
                .ignoresSafeArea()
            
            ZStack {
                // 背景：根據有無相機與超速狀態決定外觀
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        ZStack {
                            if viewModel.cameraType != nil {
                                if overSpeed {
                                    // 超速時
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(Color(red: 0.27, green: 0.04, blue: 0.04))
                                        .stroke(Color(red: 0.86, green: 0.15, blue: 0.15), lineWidth: 80)
                                        .blur(radius: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 32))
                                        .transition(.opacity)
                                } else {
                                    // 有相機且未超速
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        .transition(.opacity)
                                }
                            } else {
                                // 無相機
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white.opacity(0.8), lineWidth: dynamicNoCameraLineWidth)
                                    .blur(radius: dynamicNoCameraLineWidth)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                    .transition(.opacity)
                            }
                        }
                        .animation(.linear(duration: 0.3), value: overSpeed)
                    )
                
                // 根據是否有相機決定佈局
                if viewModel.cameraType != nil {
                    HStack {
                        // 有相機：左側顯示 CameraDistanceView
                        CameraDistanceView(distance: distance,
                                           distanceToSpeedCamera: distanceToSpeedCamera,
                                           cameraType: viewModel.cameraType!)
                        // 右側顯示速度資訊，並顯示速限 Circle
                        SpeedInfoView(speed: speed, speedLimit: speedLimit, showCircle: true)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                } else {
                    // 無相機：僅顯示速度資訊，速限 Circle 消失
                    SpeedInfoView(speed: speed, speedLimit: speedLimit, showCircle: false)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(16)
        }
        // 測試用：Overlay 控制面板
        .overlay(
            VStack {
                Spacer()
                // 調整速度的 Slider
                Slider(value: Binding(
                    get: { Double(speed) },
                    set: { speed = Int($0) }
                ), in: 0...200)
                .padding()
                
                // 切換 CameraType（有值／無值）
                VStack (spacing: 16) {
                    Button("Remove Camera") {
                        viewModel.cameraType = nil
                    }
                    Button("Add Camera") {
                        viewModel.cameraType = .cameraType1
                    }
                }
                .padding()
            }
        )
    }
}

struct CameraDistanceView: View {
    let distance: CGFloat
    let distanceToSpeedCamera: CGFloat
    let cameraType: CameraType  // 從 SpeedAlertViewModel 傳入
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 背景膠囊形狀
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                
                // 上方橘色區塊：依據 distance 改變高度
                VStack {
                    Color("color/brand/400")
                        .frame(height: orangeHeight(totalHeight: geo.size.height))
                    Spacer(minLength: 0)
                }
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                VStack {
                    // 顯示相機圖示：根據 cameraType 決定使用哪個 Icon
                    cameraIcon(for: cameraType)
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color.black.opacity(0.8))
                        .padding(.top, 12)
                    
                    // 中間虛線
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 4, dash: [12, 12]))
                        .foregroundColor(.white.opacity(0.2))
                        .frame(maxHeight: .infinity)
                    
                    // 底部距離文字
                    VStack(spacing: 0) {
                        Text("\(Int(distance))")
                            .font(.system(size: 32, weight: .bold, width: .condensed))
                            .foregroundColor(.white)
                        Text("m")
                            .font(.system(size: 32, weight: .bold, width: .condensed))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .frame(width: 83)
        .frame(maxHeight: .infinity)
    }
    
    /// 根據 distance 計算橘色區塊的高度
    private func orangeHeight(totalHeight: CGFloat) -> CGFloat {
        let ratio = distance / distanceToSpeedCamera
        return max(0, min(ratio, 1.0)) * totalHeight
    }
    
    /// 根據 CameraType 返回對應的圖示 View
    @ViewBuilder
    private func cameraIcon(for type: CameraType) -> some View {
        switch type {
        case .cameraType1:
            CameraType1()
        }
    }
}

/// 自訂 Shape：用來繪製中間的虛線
struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

/// SpeedInfoView：根據超速狀態及 showCircle 參數改變外觀
struct SpeedInfoView: View {
    let speed: Int
    let speedLimit: Int
    let showCircle: Bool
    
    var overSpeed: Bool { speed > speedLimit }
    
    var body: some View {
        VStack {
            if showCircle {
                ZStack {
                    if overSpeed {
                        // 超速：紅底 + 白描邊
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 10)
                            .strokeBorder(Color(red: 0.86, green: 0.15, blue: 0.15), lineWidth: 6)
                            .background(Circle().fill(Color(red: 0.86, green: 0.15, blue: 0.15)))
                            .frame(width: 132, height: 132)
                        
                        Text("\(speedLimit)")
                            .font(.system(size: 64, weight: .bold, width: .condensed))
                            .foregroundColor(.white)
                    } else {
                        // 未超速：白底 + 紅描邊
                        Circle()
                            .strokeBorder(Color(red: 0.86, green: 0.15, blue: 0.15), lineWidth: 10)
                            .background(Circle().fill(Color.white))
                            .frame(width: 132, height: 132)
                        
                        Text("\(speedLimit)")
                            .font(.system(size: 64, weight: .bold, width: .condensed))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 28)
            }
            
            Spacer()
            
            // 顯示目前速度資訊
            HStack {
                Text("\(speed)")
                    .font(.custom("ChakraPetch-Medium", size: 76))
                    .foregroundColor(.white)
                Text("km/h")
                    .font(.system(size: 32, weight: .medium, width: .condensed))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}


#Preview {
    SpeedAlertWidgetView()
}
