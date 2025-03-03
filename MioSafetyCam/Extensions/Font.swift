import UIKit
import SwiftUICore

extension Font {
    public static func system(
        size: CGFloat,
        weight: UIFont.Weight,
        width: UIFont.Width) -> Font
    {
        // 1
        return Font(
            UIFont.systemFont(
                ofSize: size,
                weight: weight,
                width: width)
        )
    }
}
