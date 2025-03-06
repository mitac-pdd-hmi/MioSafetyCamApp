import SwiftUI

struct ClockWidgetView: View {
    // 儲存目前時間
    @State private var currentDate = Date()
    
    // 每秒觸發一次的計時器，用來更新時間
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color("color/gray/800")
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .stroke(Color("neutral/outline"), lineWidth: 1)
                    .overlay(
                        VStack {
                            // 日期
                            Text(DateFormatterProvider.dateFormatter.string(from: currentDate))
                                .foregroundColor(Color("color/gray/300"))
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            // 使用 SlidingTimeView 來顯示時間，並帶入上下滑動動畫
                            SlidingTimeView(
                                timeString: DateFormatterProvider.timeFormatter.string(from: currentDate)
                            )
                            // 裁切外框
                            .frame(height: 56)
                            .clipped()
                            
                            Spacer()
                            
                            // AM/PM
                            Text(DateFormatterProvider.ampmFormatter.string(from: currentDate))
                                .foregroundColor(Color("color/gray/300"))
                                .font(.system(size: 20))
                        }
                        .padding(16)
                        // 每秒更新 currentDate
                        .onReceive(timer) { date in
                            self.currentDate = date
                        }
                    )
            }
            .frame(width: 172, height: 172)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

// MARK: 數字滾動動畫
struct SlidingTimeView: View {
    let timeString: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(timeString), id: \.self) { char in
                Text(String(char))
                    .font(.system(size: 56, weight: .light, design: .default))
                    .foregroundColor(.white)
                    // 讓新字由上方滑入，舊字往下方滑出
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .bottom)
                        )
                    )
                    .id(char)
            }
        }
        // 當 timeString 改變時，對更新部分執行動畫
        .animation(.easeInOut(duration: 0.9), value: timeString)
    }
}

// MARK: 時間日期格式化
struct DateFormatterProvider {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "MM月dd日 E"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        // 若想使用 12 小時制，請改成 "hh:mm"
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let ampmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "a"
        return formatter
    }()
}

#Preview {
    ClockWidgetView()
}
