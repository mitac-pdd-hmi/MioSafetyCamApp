import SwiftUI
import Foundation

struct CompassArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.4866*width, y: 0.79699*height))
        path.addLine(to: CGPoint(x: 0.13431*width, y: 0.96412*height))
        path.addCurve(to: CGPoint(x: 0.09254*width, y: 0.92349*height), control1: CGPoint(x: 0.10828*width, y: 0.97647*height), control2: CGPoint(x: 0.08092*width, y: 0.94984*height))
        path.addLine(to: CGPoint(x: 0.47149*width, y: 0.06446*height))
        path.addCurve(to: CGPoint(x: 0.52836*width, y: 0.06446*height), control1: CGPoint(x: 0.48239*width, y: 0.03974*height), control2: CGPoint(x: 0.51746*width, y: 0.03974*height))
        path.addLine(to: CGPoint(x: 0.90744*width, y: 0.92356*height))
        path.addCurve(to: CGPoint(x: 0.86568*width, y: 0.96419*height), control1: CGPoint(x: 0.91907*width, y: 0.94991*height), control2: CGPoint(x: 0.89171*width, y: 0.97653*height))
        path.addLine(to: CGPoint(x: 0.51324*width, y: 0.79699*height))
        path.addCurve(to: CGPoint(x: 0.4866*width, y: 0.79699*height), control1: CGPoint(x: 0.50481*width, y: 0.79299*height), control2: CGPoint(x: 0.49503*width, y: 0.793*height))
        path.closeSubpath()
        return path
    }
}
