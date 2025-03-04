import Foundation
import SwiftUI

// 如果你有其他檔案需要使用 CameraType，也可以把它放在這裡
enum CameraType {
    case cameraType1
    // 可根據需求新增其他相機型態
}

class SpeedAlertViewModel: ObservableObject {
    @Published var cameraType: CameraType? = .cameraType1
}
