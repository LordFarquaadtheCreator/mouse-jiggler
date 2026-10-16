import SwiftUI
internal import Combine

let frames: [String] = (1...8).map { "jiggle_\($0)" }

extension NSImage {
	func resizedForMenuBar(height: CGFloat) -> NSImage {
		let aspect = size.width / size.height
		let newSize = NSSize(width: height * aspect, height: height)
		let image = NSImage(size: newSize, flipped: false) { rect in
			self.draw(in: rect)
			return true
		}
		return image
	}
}

@MainActor
final class JiggleAnimationStateController: ObservableObject {
	@Published var state: Int = 0
	@Published var clockInterval: Double
	@Published var allowNextFrame = true
	
	/// Resized once at init, reused for every tick.
	let menuBarImages: [NSImage]
	private var timer: Timer?
	
	init(clockInterval: Double = 0.057,
		 iconHeight: CGFloat = NSStatusBar.system.thickness - 6) {
		self.clockInterval = clockInterval
		self.menuBarImages = frames.compactMap {
			NSImage(named: $0)?.resizedForMenuBar(height: iconHeight)
		}
		startClock()
	}
	
	private func startClock() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: clockInterval, repeats: true) { [weak self] _ in
			MainActor.assumeIsolated {
				guard let self, self.allowNextFrame, !self.menuBarImages.isEmpty else { return }
				self.state = (self.state + 1) % self.menuBarImages.count
			}
		}
	}
	
	func setClockInterval(_ interval: Double) {
		clockInterval = interval
		startClock()
	}
	
	func pause()  { allowNextFrame = false }
	func resume() { allowNextFrame = true }
	
	func stop() {
		timer?.invalidate()
		timer = nil
	}
}

struct JiggleAnimation: View {
	@ObservedObject var animationState: JiggleAnimationStateController
	
	var body: some View {
		if animationState.menuBarImages.indices.contains(animationState.state) {
			Image(nsImage: animationState.menuBarImages[animationState.state])
				.accessibilityLabel(Text("Jiggle frame \(animationState.state + 1)"))
		}
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
