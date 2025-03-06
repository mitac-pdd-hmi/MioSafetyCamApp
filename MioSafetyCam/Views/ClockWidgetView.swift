import SwiftUI

struct ClockWidgetView: View {
    // 儲存目前時間
    @State private var currentDate = Date()
    
    // 每秒觸發一次的計時器，用來更新時間
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color("color/gray/900"))
                    .stroke(Color("neutral/outline"), lineWidth: 1)
                    .overlay(
                        VStack {
                            // 使用 DateFormatterProvider 提供的格式化器顯示日期
                            Text(DateFormatterProvider.dateFormatter.string(from: currentDate))
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            // 使用 DateFormatterProvider 提供的格式化器顯示時間
                            Text(DateFormatterProvider.timeFormatter.string(from: currentDate))
                                .foregroundColor(.white)
                                .font(.system(size: 56))
                            
                            Spacer()
                            
                            // 使用 DateFormatterProvider 提供的格式化器顯示 AM/PM
                            Text(DateFormatterProvider.ampmFormatter.string(from: currentDate))
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .padding(16)
                        // 當計時器更新時，更新 currentDate
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

// 獨立的 DateFormatterProvider，用來提供格式化器
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
