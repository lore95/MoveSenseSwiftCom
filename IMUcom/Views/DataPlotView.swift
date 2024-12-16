import SwiftUI

struct DataPlotView: View {
    let dataPoints: [Float] // Input data (0-180 range)
    let maxValue: Float = 180 // Maximum scale value
    let minValue: Float = 0   // Minimum scale value
    
    var body: some View {
        ZStack {
            // Background border
            Rectangle()
                .stroke(Color.gray, lineWidth: 1)
            
            // Data Path
            Path { path in
                guard dataPoints.count > 1 else { return }
                
                let width: CGFloat = 300 // Fixed width
                let height: CGFloat = 200 // Fixed height
                let step = width / CGFloat(dataPoints.count - 1)
                
                // Normalize y-values
                var yValues: [CGFloat] = []
                for value in dataPoints {
                    let normalizedValue = (value - minValue) / (maxValue - minValue) * Float(height)
                    let yPosition = height - CGFloat(normalizedValue)
                    yValues.append(yPosition)
                }
                
                // Start the path
                path.move(to: CGPoint(x: 0, y: yValues[0]))
                for index in 1..<dataPoints.count {
                    let xPosition = CGFloat(index) * step
                    let yPosition = yValues[index]
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .frame(width: 300, height: 200) // Fixed frame size
    }
}
