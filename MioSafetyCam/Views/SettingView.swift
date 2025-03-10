import SwiftUI

struct SettingView: View {
    @State private var showAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Mio 測試資料更新").foregroundColor(.gray)) {
                HStack {
                    Text("測試點資料")
                        .font(.system(size: 16, weight: .regular))

                    Text("New")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .background(Color.red)
                        .cornerRadius(5)

                    Spacer()

                    Button(action: {
                        showAlert = true
                    }) {
                        Text("更新")
                            .font(.subheadline)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text("Button pressed"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    SettingView()
}
