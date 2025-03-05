import SwiftUI

struct CompassWidgetView: View {
    var body: some View {
        ZStack {
            // 背景色
            Color("color/gray/800")
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .stroke(Color("neutral/outline").opacity(0.8), lineWidth: 1)
                    .overlay(
                        ZStack {
                            CompassInfo()
                            
                            HStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color.white.opacity(0))
                                    .frame(width: .infinity)
                                Compass()
                                    .frame(width: 64, height: 64)
                            }
                        }
                        .padding(16)
                    )
            }
            .frame(width: 172, height: 172)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

// 左邊的方位和海拔資訊
struct CompassInfo: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // 左側資訊
                VStack(alignment: .leading, spacing: 4) {
                    Text("海拔高度")
                        .font(.callout)
                        .foregroundColor(Color("color/gray/300"))
                    Text("240 公尺")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }

                Spacer()
                
                // 指南資訊
                VStack(alignment: .leading, spacing: 4) {
                    Text("指南")
                        .font(.callout)
                        .foregroundColor(Color("color/gray/300"))
                    VStack(alignment: .leading) {
                        Text("SE")
                            .font(.title3.bold())
                            .foregroundColor(Color("color/brand/400"))
                        Text("125°")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                }
            }
            
            Spacer()
        }
    }
}

// 羅盤整體組件
struct Compass: View {
    var body: some View {
        ZStack {
            CompassRing()
            CompassArrow()
                .fill(Color("color/brand/400"))
                .frame(width: 32, height: 32)
                .offset(y: -2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// 羅盤刻度
struct CompassRing: View {
    let totalTicks = 24
    let ringRadius: CGFloat = 32
    
    let tickWidth: CGFloat = 2
    let tickHeight: CGFloat = 6
    
    var body: some View {
        ZStack {
            ForEach(0..<totalTicks, id: \.self) { i in
                Rectangle()
                // 在 12 點鐘方向使用品牌色，其餘則白、灰交錯
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
