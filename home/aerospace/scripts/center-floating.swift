#!/usr/bin/swift

// the script is inspired by comments from the community
// https://github.com/nikitabobko/AeroSpace/discussions/633

import AppKit

func frontmostWindow() -> AXUIElement? {
  guard let frontAppPID = NSWorkspace.shared.frontmostApplication?.processIdentifier else {
    print("Failed to get the frontmost application.")
    return nil
  }

  let appElement = AXUIElementCreateApplication(frontAppPID)
  var focusedWindow: CFTypeRef?
  let result = AXUIElementCopyAttributeValue(
    appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)

  guard result == .success, let focusedWindow else {
    print("Failed to get the focused window.")
    return nil
  }

  guard CFGetTypeID(focusedWindow) == AXUIElementGetTypeID() else {
    print("Failed to get the focused window.")
    return nil
  }

  let window = unsafeBitCast(focusedWindow, to: AXUIElement.self)
  return window
}

func windowSize(of window: AXUIElement) -> CGSize? {
  return copyAXSize(from: window, attribute: kAXSizeAttribute as CFString)
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

func setWindowPosition(_ window: AXUIElement, to position: CGPoint) -> Bool {
  var position = position
  guard let positionValue = AXValueCreate(.cgPoint, &position) else {
    return false
  }

  return AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)
    == .success
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

func run() {
  guard let window = frontmostWindow() else {
    print("No frontmost window found.")
    return
  }

  guard let currentSize = windowSize(of: window) else {
    print("Failed to get window size.")
    return
  }

  guard let screen = screen(for: window) ?? NSScreen.main else {
    print("Failed to get the monitor for the window.")
    return
  }

  let screenFrame = screen.visibleFrame
  let newX = screenFrame.origin.x + (screenFrame.width - currentSize.width) / 2
  let newY = screenFrame.origin.y + (screenFrame.height - currentSize.height) / 2
  let newPosition = CGPoint(x: newX, y: newY)

  if !setWindowPosition(window, to: newPosition) {
    print("Failed to set window position.")
  }

  Process.launchedProcess(
    launchPath: "/usr/bin/open",
    arguments: [
      "-g", "raycast://script-commands/toast?arguments=Floating%20window%20centered",
    ]
  )
}

run()
