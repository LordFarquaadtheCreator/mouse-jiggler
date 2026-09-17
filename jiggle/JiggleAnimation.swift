import SwiftUI
internal import Combine

let frames: [String] = ["jiggle_1", "jiggle_2", "jiggle_3", "jiggle_4", "jiggle_5", "jiggle_6", "jiggle_7", "jiggle_8"]

/// Controls animation state with a clock that continuously advances frames
class JiggleAnimationStateController: ObservableObject {
	@Published var state: Int
	/// Time between frame advances in seconds
	@Published var clockInterval: Double
	/// Whether the clock is allowed to advance frames (pause/resume control)
	@Published var allowNextFrame: Bool
	private var timer: Timer?
	
	init(state: Int = 0, clockInterval: Double = 0.057) {
		print("[init] state=\(state), clockInterval=\(clockInterval)")
		self.state = state
		self.clockInterval = clockInterval
		self.allowNextFrame = true
		print("[init] initialized")
	}
	
	/// Starts the global clock timer that advances frames continuously
	private func startClock() {
		print("[startClock] starting clock with interval=\(clockInterval)")
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: clockInterval, repeats: true) { _ in
			guard self.allowNextFrame else { return }
			self.advanceFrame()
		}
	}
	
	/// Advances to the next frame in the animation sequence
	private func advanceFrame() {
		withAnimation(.easeInOut(duration: clockInterval)) {
			state = (state + 1) % frames.count
		}
	}
	
	func setClockInterval(_ interval: Double) {
		print("[setClockInterval] old=\(clockInterval), new=\(interval)")
		clockInterval = interval
		startClock()
	}
	
	/// Pauses frame advancement by blocking the clock
	func pause() {
		print("[pause] pausing")
		allowNextFrame = false
	}
	
	/// Resumes frame advancement by unblocking the clock
	func resume() {
		print("[resume] resuming")
		allowNextFrame = true
	}
	
	/// Kills animation
	func stop() {
		print("[stop] stopping clock")
		timer?.invalidate()
		timer = nil
	}
}

struct JiggleAnimation: View {
	@ObservedObject var animationState: JiggleAnimationStateController

    var body: some View {
        let image = Image(frames[animationState.state])
            .resizable()
			.aspectRatio(contentMode: .fit)

        Group {
			image
        }
        .accessibilityLabel(Text("Jiggle frame \(animationState.state + 1)"))
    }
}

// MARK: - Previews
struct JiggleAnimation_Previews: PreviewProvider {
    /// Auto-cycling preview: cycles through states every `clockInterval` seconds.
    struct AutoCyclingPreview: View {
		@State private var clockInterval: Double = 0.3
		@StateObject private var animationState = JiggleAnimationStateController()

        var body: some View {
            VStack(spacing: 16) {
                JiggleAnimation(animationState: animationState)
                    .frame(width: 160, height: 160)

                HStack {
                    Text("Interval: \(clockInterval, specifier: "%.2f")s")
					Slider(value: $clockInterval, in: 0.05...1, step: 0.05)
                        .frame(maxWidth: 220)
                }

                Button(animationState.allowNextFrame ? "Pause" : "Resume") {
                    if animationState.allowNextFrame {
                        animationState.pause()
                    } else {
                        animationState.resume()
                    }
                }
            }
            .padding()
            .onAppear {
				animationState.setClockInterval(clockInterval)
			}
            .onDisappear {
				animationState.stop()
			}
			.onChange(of: clockInterval) {
				animationState.setClockInterval(clockInterval)
			}
        }
    }

	static var previews: some View {
		Group {
			AutoCyclingPreview()
				.previewDisplayName("Auto-cycling")
		}
	}
}
