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
                    let sway = sin(elapsed * piece.swayFactor) * 15
                    let currentX = piece.position.x + sway
                    let currentY = piece.position.y + (piece.finalPosition.y - piece.position.y) * timeProgress * piece.speed
                    
                    context.opacity = piece.opacity * (1 - timeProgress)
                    context.fill(
                        Path(ellipseIn: CGRect(x: 0, y: 0, width: 8, height: 8)),
                        with: .color(piece.color)
                    )
                    context.scaleBy(x: piece.scale, y: piece.scale)
                    context.rotate(by: .degrees(piece.rotation + elapsed * 120))
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
        elapsed = 0
        // Create initial pieces
        pieces = (0..<50).map { _ in
            let startX = UIScreen.main.bounds.width / 2
            let startY = -50.0 // Start above screen
            let finalX = CGFloat.random(in: -20...UIScreen.main.bounds.width + 20)
            let finalY = UIScreen.main.bounds.height + 100
            
            return ConfettiPiece(
                position: CGPoint(x: startX, y: startY),
                finalPosition: CGPoint(x: finalX, y: finalY),
                rotation: Double.random(in: 0...360),
                scale: CGFloat.random(in: 0.7...1.4),
                opacity: 1.0,
                color: ConfettiPiece.colors.randomElement()!,
                speed: Double.random(in: 0.8...1.2),
                swayFactor: Double.random(in: 2...4)
            )
        }
        
        // Animate using Timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            withAnimation {
                elapsed += 1/60
                if elapsed >= duration {
                    pieces = []
                    isVisible = false
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
} 