import AppKit

struct MoveDelta {
  let y: CGFloat
  let x: CGFloat

  init?(_ args: [String]) {
    guard args.count == 2,
      let y = Int(args[0]),
      let x = Int(args[1])
    else {
      return nil
    }

    self.y = CGFloat(y)
    self.x = CGFloat(x)
  }
}

func writeError(_ message: String) {
  if let data = (message + "\n").data(using: .utf8) {
    FileHandle.standardError.write(data)
  }
}

func frontmostWindow() -> AXUIElement? {
  guard let frontAppPID = NSWorkspace.shared.frontmostApplication?.processIdentifier else {
    writeError("Failed to get the frontmost application")
    return nil
  }

  let appElement = AXUIElementCreateApplication(frontAppPID)
  var focusedWindow: CFTypeRef?
  let result = AXUIElementCopyAttributeValue(
    appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

  guard result == .success, let focusedWindow else {
    writeError("Failed to get the focused window")
    return nil
  }

  guard CFGetTypeID(focusedWindow) == AXUIElementGetTypeID() else {
    writeError("Failed to get the focused window")
    return nil
  }

  let window = unsafeBitCast(focusedWindow, to: AXUIElement.self)
  return window
}

func copyAXPoint(from element: AXUIElement, attribute: CFString) -> CGPoint? {
  var value: CFTypeRef?

  guard AXUIElementCopyAttributeValue(element, attribute, &value) == .success,
    let value,
    CFGetTypeID(value) == AXValueGetTypeID()
  else {
    return nil
  }

  let axValue = unsafeBitCast(value, to: AXValue.self)
  var point = CGPoint.zero
  guard AXValueGetValue(axValue, .cgPoint, &point) else {
    return nil
  }
  return point
}

func isAttributeSettable(_ element: AXUIElement, attribute: CFString) -> Bool? {
  var settable = DarwinBoolean(false)
  guard AXUIElementIsAttributeSettable(element, attribute, &settable) == .success else {
    return nil
  }
  return settable.boolValue
}

func setWindowPosition(_ window: AXUIElement, to position: CGPoint) -> Bool {
  var position = position
  guard let positionValue = AXValueCreate(.cgPoint, &position) else {
    return false
  }

  return AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)
    == .success
}

func run() {
  guard AXIsProcessTrusted() else {
    writeError("Accessibility permission is required to control windows")
    exit(2)
  }

  let args = Array(CommandLine.arguments.dropFirst())
  guard let delta = MoveDelta(args) else {
    writeError("Usage: swift move-floating.swift <dy> <dx>")
    exit(1)
  }

  guard let window = frontmostWindow() else {
    exit(3)
  }

  guard let currentPosition = copyAXPoint(from: window, attribute: kAXPositionAttribute as CFString)
  else {
    writeError("Failed to read window position")
    exit(4)
  }

  guard let positionIsSettable = isAttributeSettable(
    window, attribute: kAXPositionAttribute as CFString),
    positionIsSettable
  else {
    writeError("Failed to set window position")
    exit(4)
  }

  let newPosition = CGPoint(
    x: currentPosition.x + delta.x,
    y: currentPosition.y - delta.y
  )

  if setWindowPosition(window, to: newPosition) {
    exit(0)
  }

  writeError("Failed to set window position")
  exit(4)
}

run()
