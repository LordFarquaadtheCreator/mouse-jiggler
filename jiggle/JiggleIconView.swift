import SwiftUI

// Displays and animates the jiggle icon
struct JiggleIconView: View {
    let isJiggling: Bool
    let animationSpeedMultiplier: Double

    @StateObject private var animationState = JiggleAnimationStateController()

    var body: some View {
        JiggleAnimation(animationState: animationState)
            .frame(width: 64, height: 64)
            .onAppear {
                syncAnimation()
            }
            .onChange(of: isJiggling) { _, _ in
                syncAnimation()
            }
            .onChange(of: animationSpeedMultiplier) { _, _ in
                syncAnimation()
            }
            .onDisappear {
                animationState.stop()
            }
    }

    /// Applies the current state at launch too, not only on later changes.
    private func syncAnimation() {
        animationState.setClockInterval(0.057 / animationSpeedMultiplier)
        if isJiggling {
            animationState.start()
        } else {
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
