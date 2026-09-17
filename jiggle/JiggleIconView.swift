import SwiftUI

// Displays and animates the jiggle icon
struct JiggleIconView: View {
    let isJiggling: Bool
    let animationSpeedMultiplier: Double

    @StateObject private var animationState = JiggleAnimationStateController()
    @State private var isHovering: Bool = false

    var body: some View {
        JiggleAnimation(animationState: animationState)
            .frame(width: 64, height: 64)
            .onChange(of: isJiggling) { _, on in
                if on {
                    animationState.resume()
                } else {
					animationState.pause()
                }
            }
            .onChange(of: animationSpeedMultiplier) { _, multiplier in
                let baseInterval = 0.057
                let adjustedInterval = baseInterval / multiplier
                animationState.setClockInterval(adjustedInterval)
            }
            .onAppear {
                let baseInterval = 0.057
                let adjustedInterval = baseInterval / animationSpeedMultiplier
                animationState.setClockInterval(adjustedInterval)
            }
            .onDisappear {
                animationState.stop()
            }
    }
}

#Preview {
    VStack() {
        JiggleIconView(isJiggling: false, animationSpeedMultiplier: 1.0)
            .padding()
        HStack() {
            JiggleIconView(isJiggling: true, animationSpeedMultiplier: 1.0)
                .padding()
        }
        .background(Color.black)
    }
}
