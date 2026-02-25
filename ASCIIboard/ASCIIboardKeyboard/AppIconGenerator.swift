import SwiftUI

/// A SwiftUI view that generates the ASCIIboard app icon design
/// Screenshot this view at 1024x1024 to create your app icon
struct AppIconGenerator: View {
    var body: some View {
        ZStack {
            // Cave wall background - textured stone look
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.35, blue: 0.3),
                    Color(red: 0.3, green: 0.25, blue: 0.2),
                    Color(red: 0.35, green: 0.3, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Cave texture overlay
            Canvas { context, size in
                for _ in 0..<200 {
                    let x = Double.random(in: 0...size.width)
                    let y = Double.random(in: 0...size.height)
                    let radius = Double.random(in: 1...3)
                    
                    var path = Path()
                    path.addEllipse(in: CGRect(x: x, y: y, width: radius, height: radius))
                    context.fill(path, with: .color(.white.opacity(Double.random(in: 0.05...0.15))))
                }
            }
            
            // ASCII art "painted" on the wall in primitive style
            VStack(spacing: 8) {
                // Simple face made from ASCII characters
                Text("(◕‿◕)")
                    .font(.system(size: 120, design: .monospaced))
                    .fontWeight(.black)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.9, green: 0.7, blue: 0.5), // Ochre
                                Color(red: 0.7, green: 0.5, blue: 0.3)  // Darker ochre
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 2, y: 2)
                    .shadow(color: Color(red: 0.9, green: 0.7, blue: 0.5).opacity(0.5), radius: 8, x: -1, y: -1)
                
                // "Painted" effect with hand prints or primitive marks
                HStack(spacing: 20) {
                    Circle()
                        .fill(Color(red: 0.8, green: 0.4, blue: 0.3).opacity(0.6))
                        .frame(width: 40, height: 40)
                    Circle()
                        .fill(Color(red: 0.8, green: 0.4, blue: 0.3).opacity(0.5))
                        .frame(width: 35, height: 35)
                    Circle()
                        .fill(Color(red: 0.8, green: 0.4, blue: 0.3).opacity(0.6))
                        .frame(width: 40, height: 40)
                }
                .offset(y: -10)
            }
            
            // Edge darkening for depth
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.2)
                ],
                startPoint: .center,
                endPoint: .bottomTrailing
            )
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

// MARK: - Preview

#Preview("App Icon - 1024x1024") {
    AppIconGenerator()
        .frame(width: 1024, height: 1024)
}

#Preview("App Icon - Standard Size") {
    AppIconGenerator()
        .frame(width: 300, height: 300)
}
