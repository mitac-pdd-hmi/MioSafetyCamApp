import SwiftUI

struct SpeedAlertWidgetView: View {
    @State private var distance: CGFloat = 250 // 初始距離 500m
    
    var body: some View {
        ZStack {
            Color("color/gray/800")
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                HStack {
                    // 傳入動態 distance 給 CameraDistanceView
                    CameraDistanceView(distance: distance)
                    HStack{
                        SpeedInfoView()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(16)
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(16)
        }
    }
}

struct CameraDistanceView: View {
    /// 當前距離（單位：m）
    let distance: CGFloat
    /// 最大距離（橘色區塊滿高時的距離）
    let maxDistance: CGFloat = 500
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 背景膠囊形狀（深色底板）
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                    .shadow(radius: 2)
                
                // 上方橘色區域，依據距離改變高度
                VStack(spacing: 0) {
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
                    VStack {
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
        }
        .frame(width: 83)
        .frame(maxHeight: .infinity)
    }
    
    /// 根據 distance 計算橘色區塊的高度
    private func orangeHeight(totalHeight: CGFloat) -> CGFloat {
        let ratio = distance / maxDistance
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
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .strokeBorder(Color.red, lineWidth: 10)
                    .background(Circle().fill(Color.white))
                    .frame(width: 132, height: 132)
                
                Text("110")
                    .font(.system(size: 64, weight: .bold, width: .condensed))
                    .foregroundColor(.black)
            }
            .padding(.top, 28)
            
            Spacer()
            
            HStack {
                Text("100")
                    .font(.custom("ChakraPetch-Medium", size: 76))
                    .foregroundColor(.white)
                Text("km/h")
                    .font(.system(size: 32, weight: .medium, width: .condensed))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
            Spacer()
        }
    }
}

#Preview {
    SpeedAlertWidgetView()
}
