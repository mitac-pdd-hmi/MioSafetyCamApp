import SwiftUI

struct SpeedAlertWidgetView: View {
    var body: some View {
        ZStack {
            Color("color/gray/900")
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("color/gray/900"))
                    .frame(width: 353, height: 353)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                HStack(spacing: 0) {
                    CameraDistanceView()
                    Spacer(minLength: 0)
                    SpeedInfoView()
                }
                .padding(16)
                .frame(width: 353, height: 353)
            }
        }
    }
}

struct CameraDistanceView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.orange
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            ZStack {
                Color(.systemGray4)
                
                VStack {
                    Text("500")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                    Text("m")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                }
                
            }
        }
        .frame(width: 83)
        .frame(maxHeight: .infinity)
    }
}

struct SpeedInfoView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .strokeBorder(Color.red, lineWidth: 8)
                    .background(Circle().fill(Color.white))
                    .frame(width: 132, height: 132)
                
                Text("110")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.top, 24)
            
            Spacer()
            
            Text("100 km/h")
                .font(.system(size: 76, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    SpeedAlertWidgetView()
}
