#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Set Default Audio Output
// @raycast.mode silent
// @raycast.icon 🔉

// Optional parameters:
// @raycast.argument1 { "type": "text", "placeholder": "Device Name" }

import CoreAudio
import Foundation

let DEVICE_NAME = Array(CommandLine.arguments.dropFirst()).first!

let globalAddress = AudioObjectPropertyAddress(
  mSelector: 0,
  mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
  mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))

func setAudioOutput(named targetName: String) -> Bool {
  var address = globalAddress
  address.mSelector = AudioObjectPropertySelector(kAudioHardwarePropertyDevices)

  var propsize: UInt32 = 0
  guard
    AudioObjectGetPropertyDataSize(
      AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propsize) == 0
  else {
    return false
  }

  let numDevices = Int(propsize / UInt32(MemoryLayout<AudioDeviceID>.size))
  var devids = [AudioDeviceID](repeating: 0, count: numDevices)

  guard
    AudioObjectGetPropertyData(
      AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propsize, &devids) == 0
  else {
    return false
  }

  for deviceID in devids {
    var nameAddress = globalAddress
    nameAddress.mSelector = AudioObjectPropertySelector(kAudioDevicePropertyDeviceNameCFString)

    var name: CFString?
    var nameSize = UInt32(MemoryLayout<CFString?>.size)

    guard AudioObjectGetPropertyData(deviceID, &nameAddress, 0, nil, &nameSize, &name) == 0,
      let deviceName = name as String?,
      deviceName == targetName
    else {
      continue
    }

    var outputAddress = globalAddress
    outputAddress.mSelector = AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice)
    var mutableDeviceID = deviceID

    return AudioObjectSetPropertyData(
      AudioObjectID(kAudioObjectSystemObject),
      &outputAddress,
      0,
      nil,
      UInt32(MemoryLayout<AudioDeviceID>.size),
      &mutableDeviceID
    ) == 0
  }

  return false
}

Process.launchedProcess(
  launchPath: "/usr/bin/open",
  arguments: ["-jg", "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-1"]
)

for _ in 0..<10 {
  if setAudioOutput(named: DEVICE_NAME) {
    Process.launchedProcess(
      launchPath: "/usr/bin/osascript",
      arguments: [
        "-e",
        """
          tell application "System Events"
            tell process "Raycast"
              keystroke "w" using command down
            end tell
          end tell
        """,
      ]
    )
    print("\(DEVICE_NAME) was set to default audio output")
    exit(0)
  }
  usleep(useconds_t(0.5 * 1_000_000))
}

print("Error: \(DEVICE_NAME) not available")
exit(1)
