// the script is inspired by comments from the community
// https://github.com/nikitabobko/AeroSpace/discussions/633
import AppKit

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

func copyAXSize(from element: AXUIElement, attribute: CFString) -> CGSize? {
  var value: CFTypeRef?

  guard AXUIElementCopyAttributeValue(element, attribute, &value) == .success,
    let value,
    CFGetTypeID(value) == AXValueGetTypeID()
  else {
    return nil
  }

  let axValue = unsafeBitCast(value, to: AXValue.self)
  var size = CGSize.zero

  guard AXValueGetValue(axValue, .cgSize, &size) else {
    return nil
  }
  return size
}

func setWindowPosition(_ window: AXUIElement, to position: CGPoint) -> Bool {
  var position = position
  guard let positionValue = AXValueCreate(.cgPoint, &position) else {
    return false
  }

  return AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)
    == .success
}

func screen(for window: AXUIElement) -> NSScreen? {
  guard let origin = copyAXPoint(from: window, attribute: kAXPositionAttribute as CFString),
    let size = copyAXSize(from: window, attribute: kAXSizeAttribute as CFString)
  else {
    return nil
  }

  let windowFrame = CGRect(origin: origin, size: size)
  return NSScreen.screens.first { $0.frame.intersects(windowFrame) }
}

func run() {
  guard AXIsProcessTrusted() else {
    writeError("Accessibility permission is required to control windows")
    exit(1)
  }

  let args = Array(CommandLine.arguments.dropFirst())
  guard args.isEmpty else {
    writeError("Usage: center-floating")
    exit(2)
  }

  guard let window = frontmostWindow() else {
    exit(1)
  }

  guard let currentSize = copyAXSize(from: window, attribute: kAXSizeAttribute as CFString) else {
    writeError("Failed to read window position or size")
    exit(1)
  }

  guard let screen = screen(for: window) ?? NSScreen.main else {
    writeError("Failed to get the monitor for the window")
    exit(1)
  }

  let screenFrame = screen.visibleFrame
  let newX = screenFrame.origin.x + (screenFrame.width - currentSize.width) / 2
  let newY = screenFrame.origin.y + (screenFrame.height - currentSize.height) / 2
  let newPosition = CGPoint(x: newX, y: newY)

  if setWindowPosition(window, to: newPosition) {
    exit(0)
  }

  writeError("Failed to set window position")
  exit(1)
}

run()
