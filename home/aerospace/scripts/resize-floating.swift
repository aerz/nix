#!/usr/bin/swift

import AppKit

struct ResizeDelta {
  let width: CGFloat
  let height: CGFloat

  init?(_ args: [String]) {
    guard args.count >= 2,
      let width = Double(args[0]),
      let height = Double(args[1])
    else {
      return nil
    }

    self.width = CGFloat(width)
    self.height = CGFloat(height)
  }
}

func frontmostWindow() -> AXUIElement? {
  guard let frontAppPID = NSWorkspace.shared.frontmostApplication?.processIdentifier else {
    print("Failed to get the frontmost application")
    return nil
  }

  let appElement = AXUIElementCreateApplication(frontAppPID)
  var focusedWindow: CFTypeRef?
  let result = AXUIElementCopyAttributeValue(
    appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

  guard result == .success, let focusedWindow else {
    print("Failed to get the focused window")
    return nil
  }

  guard CFGetTypeID(focusedWindow) == AXUIElementGetTypeID() else {
    print("Failed to get the focused window")
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

func setWindowSize(_ window: AXUIElement, to size: CGSize) -> Bool {
  var size = size
  guard let sizeValue = AXValueCreate(.cgSize, &size) else {
    return false
  }

  return AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue) == .success
}

func run() {
  guard AXIsProcessTrusted() else {
    print("Accessibility permission is required to control windows")
    return
  }

  let args = Array(CommandLine.arguments.dropFirst())
  guard let delta = ResizeDelta(args) else {
    print("Usage: resize-floating <deltaWidth> <deltaHeight>")
    return
  }

  guard let window = frontmostWindow() else {
    print("No frontmost window found")
    return
  }

  guard let position = copyAXPoint(from: window, attribute: kAXPositionAttribute as CFString),
    let size = copyAXSize(from: window, attribute: kAXSizeAttribute as CFString)
  else {
    print("Failed to read window position or size")
    return
  }

  let newWidth = size.width + delta.width
  let newHeight = size.height + delta.height

  if newWidth <= 1 || newHeight <= 1 {
    print("Requested size is too small")
    return
  }

  let newPosition = CGPoint(
    x: position.x - (delta.width / 2),
    y: position.y - (delta.height / 2)
  )
  let newSize = CGSize(width: newWidth, height: newHeight)

  let positionSet = setWindowPosition(window, to: newPosition)
  let sizeSet = setWindowSize(window, to: newSize)

  if positionSet && sizeSet {
    Process.launchedProcess(
      launchPath: "/usr/bin/open",
      arguments: [
        "-g", "raycast://script-commands/toast?arguments=Floating%20window%20resized",
      ]
    )
  } else {
    print("Failed to resize the window")
  }
}

run()
