import SwiftUI

struct CompassWidgetView: View {
    @State private var angleInput: String = "0"
    @State private var currentAngle: Double = 0  // 控制 CompassArrow 的旋轉角度

    var body: some View {
        ZStack {
            Color("color/gray/800")
                .ignoresSafeArea()
            
            // 羅盤卡片
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .stroke(Color("neutral/outline"), lineWidth: 1)
                    .overlay(
                        ZStack {
                            CompassInfo()
                            
                            // 右下角的羅盤
                            HStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color.white.opacity(0))
                                // 傳入 ringRadius 與 currentAngle 控制 CompassArrow 旋轉
                                Compass(ringRadius: 32, angle: currentAngle)
                                    .frame(width: 64, height: 64)
                            }
                        }
                        .padding(16)
                    )
            }
            .frame(width: 172, height: 172)
            .aspectRatio(1, contentMode: .fit)
            
            // （測試用）輸入角度看效果
            VStack {
                Spacer()
                AngleInputField(angleInput: $angleInput, currentAngle: $currentAngle)
            }
        }
    }
}

// MARK: （測試用）羅盤指針旋轉輸入
struct AngleInputField: View {
    @Binding var angleInput: String
    @Binding var currentAngle: Double

    var body: some View {
        TextField("輸入角度測試旋轉", text: $angleInput, onCommit: {
            if let newAngle = Double(angleInput) {
                let normalizedNew = newAngle.truncatingRemainder(dividingBy: 360)
                let normalizedCurrent = currentAngle.truncatingRemainder(dividingBy: 360)
                var delta = normalizedNew - normalizedCurrent
                // 調整以取得最短轉動路徑
                if delta > 180 {
                    delta -= 360
                } else if delta < -180 {
                    delta += 360
                }
                let finalAngle = currentAngle + delta
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentAngle = finalAngle
                }
            }
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 160)
    }
}

// MARK: 左側資訊
struct CompassInfo: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // 海拔資訊
                VStack(alignment: .leading, spacing: 4) {
                    Text("海拔高度")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("color/gray/300"))
                    Text("240 公尺")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                // 指南資訊
                VStack(alignment: .leading, spacing: 4) {
                    Text("指南")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("color/gray/300"))
                    VStack(alignment: .leading) {
                        Text("SE")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("color/brand/400"))
                        Text("125°")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            Spacer()
        }
    }
}

// MARK: 羅盤組件
struct Compass: View {
    var ringRadius: CGFloat
    var angle: Double

    var body: some View {
        ZStack {
            CompassRing(ringRadius: ringRadius)
            // 此處 CompassArrow() 為外部引入的組件
            CompassArrow()
                .fill(Color("color/brand/400"))
                .frame(width: 32, height: 32)
                .offset(y: -2)
                .rotationEffect(.degrees(angle))
        }
    }
}

// MARK: 羅盤刻度
struct CompassRing: View {
    let totalTicks = 24
    var ringRadius: CGFloat
    let tickWidth: CGFloat = 2
    let tickHeight: CGFloat = 6

    var body: some View {
        ZStack {
            ForEach(0..<totalTicks, id: \.self) { i in
                Rectangle()
                    .fill(i == 0 ? Color("color/brand/400") : (i % 2 == 0 ? Color.white : Color.gray))
                    .frame(width: tickWidth, height: tickHeight)
                    .offset(y: -ringRadius + (tickHeight / 2))
                    .rotationEffect(.degrees(Double(i) * (360.0 / Double(totalTicks))))
            }
        }
    }
}

#Preview {
    CompassWidgetView()
}
