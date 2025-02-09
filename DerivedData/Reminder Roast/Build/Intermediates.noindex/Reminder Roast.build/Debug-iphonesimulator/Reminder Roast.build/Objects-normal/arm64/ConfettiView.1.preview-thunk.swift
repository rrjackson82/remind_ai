import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/ConfettiView.swift", line: 1)
import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    var finalPosition: CGPoint
    var rotation: Double
    var scale: CGFloat
    var opacity: Double
    let color: Color
    var speed: Double
    var swayFactor: Double
    
    static let colors: [Color] = [
        .blue, .red, .green, .yellow, .purple, .orange, 
        .pink, .mint, .cyan, .indigo, .teal
    ]
}

struct ConfettiView: View {
    @Binding var isVisible: Bool
    let duration: Double = 3.0
    
    @State private var pieces: [ConfettiPiece] = []
    @State private var elapsed: Double = 0
    @State private var timer: Timer?
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for piece in pieces {
                    let timeProgress = elapsed / duration
                    
                    // Calculate current position with swaying motion
                    let sway = sin(elapsed * piece.swayFactor) * __designTimeInteger("#11341_0", fallback: 15)
                    let currentX = piece.position.x + sway
                    let currentY = piece.position.y + (piece.finalPosition.y - piece.position.y) * timeProgress * piece.speed
                    
                    context.opacity = piece.opacity * (__designTimeInteger("#11341_1", fallback: 1) - timeProgress)
                    context.fill(
                        Path(ellipseIn: CGRect(x: __designTimeInteger("#11341_2", fallback: 0), y: __designTimeInteger("#11341_3", fallback: 0), width: __designTimeInteger("#11341_4", fallback: 8), height: __designTimeInteger("#11341_5", fallback: 8))),
                        with: .color(piece.color)
                    )
                    context.scaleBy(x: piece.scale, y: piece.scale)
                    context.rotate(by: .degrees(piece.rotation + elapsed * __designTimeInteger("#11341_6", fallback: 120)))
                    context.transform = .identity
                    context.transform = CGAffineTransform(translationX: currentX, y: currentY)
                }
            }
        }
        .onChange(of: isVisible) { oldValue, newValue in
            if newValue {
                startConfetti()
            }
        }
    }
    
    private func startConfetti() {
        elapsed = __designTimeInteger("#11341_7", fallback: 0)
        // Create initial pieces
        pieces = (__designTimeInteger("#11341_8", fallback: 0)..<__designTimeInteger("#11341_9", fallback: 50)).map { _ in
            let startX = UIScreen.main.bounds.width / __designTimeInteger("#11341_10", fallback: 2)
            let startY = __designTimeFloat("#11341_11", fallback: -50.0) // Start above screen
            let finalX = CGFloat.random(in: __designTimeInteger("#11341_12", fallback: -20)...UIScreen.main.bounds.width + __designTimeInteger("#11341_13", fallback: 20))
            let finalY = UIScreen.main.bounds.height + __designTimeInteger("#11341_14", fallback: 100)
            
            return ConfettiPiece(
                position: CGPoint(x: startX, y: startY),
                finalPosition: CGPoint(x: finalX, y: finalY),
                rotation: Double.random(in: __designTimeInteger("#11341_15", fallback: 0)...__designTimeInteger("#11341_16", fallback: 360)),
                scale: CGFloat.random(in: __designTimeFloat("#11341_17", fallback: 0.7)...__designTimeFloat("#11341_18", fallback: 1.4)),
                opacity: __designTimeFloat("#11341_19", fallback: 1.0),
                color: ConfettiPiece.colors.randomElement()!,
                speed: Double.random(in: __designTimeFloat("#11341_20", fallback: 0.8)...__designTimeFloat("#11341_21", fallback: 1.2)),
                swayFactor: Double.random(in: __designTimeInteger("#11341_22", fallback: 2)...__designTimeInteger("#11341_23", fallback: 4))
            )
        }
        
        // Animate using Timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: __designTimeInteger("#11341_24", fallback: 1)/__designTimeInteger("#11341_25", fallback: 60), repeats: __designTimeBoolean("#11341_26", fallback: true)) { _ in
            withAnimation {
                elapsed += __designTimeInteger("#11341_27", fallback: 1)/__designTimeInteger("#11341_28", fallback: 60)
                if elapsed >= duration {
                    pieces = []
                    isVisible = __designTimeBoolean("#11341_29", fallback: false)
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
} 
