import CoreGraphics

func jiggleOnce() {
    let movements: [CGFloat] = [2, 4, 8, 16]
    let dx = movements.randomElement()!
    let dy = movements.randomElement()!

    guard let src = CGEventSource(stateID: .hidSystemState) else { return }
    guard let event = CGEvent(source: src) else { return }

    let pt = event.location
    let newX = pt.x + dx
    let newY = pt.y + dy

    guard let moveEvent = CGEvent(
        mouseEventSource: src,
        mouseType: .mouseMoved,
        mouseCursorPosition: CGPoint(x: newX, y: newY),
        mouseButton: .left
    ) else { return }

    moveEvent.post(tap: .cghidEventTap)
}
