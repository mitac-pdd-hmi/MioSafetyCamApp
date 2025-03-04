import SwiftUI

struct SpeedAlertWidgetView: View {
    @State private var speed: Int = 90 // 當前速度
    @State private var speedLimit: Int = 110 // 速限
    @State private var distance: CGFloat = 250 // 當前距離
    @State private var distanceToSpeedCamera: CGFloat = 500 // 離 speed camera 多遠
    
    var body: some View {
        
        let overSpeed = speed > speedLimit
        
        ZStack {
            Color("color/gray/800")
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        ZStack {
                            if overSpeed {
                                // 超速的視覺效果
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color(red: 0.27, green: 0.04, blue: 0.04))
                                    .stroke(Color(red: 0.86, green: 0.15, blue: 0.15), lineWidth: 80)
                                    .blur(radius: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                    .transition(.opacity)
                            } else {
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    .transition(.opacity)
                            }
                        }
                        .animation(.linear(duration: 0.3), value: overSpeed)
                    )
                
                HStack {
                    // 傳入 distance 與 distanceToSpeedCamera 到 CameraDistanceView
                    CameraDistanceView(distance: distance, distanceToSpeedCamera: distanceToSpeedCamera)
                    
                    SpeedInfoView(speed: speed, speedLimit: speedLimit)
                        .frame(maxWidth: .infinity)
                }
                .padding(16)
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(16)
        }
        // 測試用正式時請刪除
        .overlay(
            VStack {
                Spacer()
                Slider(value: Binding(
                    get: { Double(speed) },
                    set: { speed = Int($0) }
                ), in: 0...200)
                .padding()
            }
        )
    }
}

struct CameraDistanceView: View {
    let distance: CGFloat
    let distanceToSpeedCamera: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 背景膠囊形狀
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                
                // 上方橘色區域，依據 distance 改變高度
                VStack {
                    Color("color/brand/400")
                        .frame(height: orangeHeight(totalHeight: geo.size.height))
                    Spacer(minLength: 0)
                }
                .mask(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                
                VStack {
                    // 相機圖示（置頂）
                    CameraType1()
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

struct SpeedInfoView: View {
    let speed: Int
    let speedLimit: Int
    
    var overSpeed: Bool {
        speed > speedLimit
    }
    
    var body: some View {
        VStack {
            ZStack {
                if overSpeed {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 10)
                        .strokeBorder(Color.red, lineWidth: 6)
                        .background(Circle().fill(Color.red))
                        .frame(width: 132, height: 132)
                    
                    Text("\(speedLimit)")
                        .font(.system(size: 64, weight: .bold, width: .condensed))
                        .foregroundColor(.white)
                } else {
                    Circle()
                        .strokeBorder(Color.red, lineWidth: 10)
                        .background(Circle().fill(Color.white))
                        .frame(width: 132, height: 132)
                    
                    Text("\(speedLimit)")
                        .font(.system(size: 64, weight: .bold, width: .condensed))
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 28)
            
            Spacer()
            
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
