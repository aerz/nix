#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Set Default Audio Output
// @raycast.mode silent
// @raycast.icon 🔉

// Optional parameters:
// @raycast.argument1 { "type": "text", "placeholder": "Device Name" }

import CoreAudio
import Darwin
import Foundation
import IOBluetooth
import IOKit

let arguments = Array(CommandLine.arguments.dropFirst())
guard let deviceName = arguments.first, !deviceName.isEmpty else {
  FileHandle.standardError.write(Data("Missing device name parameter\n".utf8))
  exit(2)
}

let globalPropertyAddress = AudioObjectPropertyAddress(
  mSelector: 0,
  mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
  mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMain))

func withStderrSuppressed<T>(_ body: () -> T) -> T {
  let originalFD = dup(STDERR_FILENO)
  guard originalFD != -1 else {
    return body()
  }

  let devNullFD = open("/dev/null", O_WRONLY)
  if devNullFD != -1 {
    _ = dup2(devNullFD, STDERR_FILENO)
    close(devNullFD)
  }

  defer {
    _ = dup2(originalFD, STDERR_FILENO)
    close(originalFD)
  }

  return body()
}

func setDefaultOutputDevice(named deviceName: String) -> Bool {
  var address = globalPropertyAddress
  address.mSelector = AudioObjectPropertySelector(kAudioHardwarePropertyDevices)

  var propertySize: UInt32 = 0
  guard
    AudioObjectGetPropertyDataSize(
      AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propertySize) == 0
  else {
    return false
  }

  let numDevices = Int(propertySize / UInt32(MemoryLayout<AudioDeviceID>.size))
  var deviceIDs = [AudioDeviceID](repeating: 0, count: numDevices)

  guard
    AudioObjectGetPropertyData(
      AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propertySize, &deviceIDs) == 0
  else {
    return false
  }

  for deviceID in deviceIDs {
    var deviceNameAddress = globalPropertyAddress
    deviceNameAddress.mSelector = AudioObjectPropertySelector(
      kAudioDevicePropertyDeviceNameCFString)

    var name: CFString?
    var deviceNameSize = UInt32(MemoryLayout<CFString?>.size)

    guard
      AudioObjectGetPropertyData(
        deviceID, &deviceNameAddress, 0, nil, &deviceNameSize, &name) == 0,
      let foundName = name as String?,
      foundName == deviceName
    else {
      continue
    }

    var outputAddress = globalPropertyAddress
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

func normalizedName(_ value: String) -> String {
  value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

func deviceMatches(_ device: IOBluetoothDevice, key: String) -> Bool {
  let candidates = [device.name, device.addressString].compactMap { $0 }
  return candidates.contains { normalizedName($0) == key }
}

func pairedDevice(matching key: String) -> IOBluetoothDevice? {
  guard let paired = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
    return nil
  }

  return paired.first { deviceMatches($0, key: key) }
}

final class BluetoothInquiryHelper: NSObject, IOBluetoothDeviceInquiryDelegate {
  private let matchKey: String
  private var foundDevice: IOBluetoothDevice?
  private var isComplete = false
  private var deviceInquiry: IOBluetoothDeviceInquiry?

  init(matchKey: String) {
    self.matchKey = matchKey
  }

  func discover(timeout: TimeInterval) -> IOBluetoothDevice? {
    deviceInquiry = IOBluetoothDeviceInquiry(delegate: self)
    guard let deviceInquiry = deviceInquiry else {
      return nil
    }

    let startResult = deviceInquiry.start()
    if startResult != kIOReturnSuccess {
      return nil
    }

    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline && !isComplete {
      RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.1))
    }

    deviceInquiry.stop()
    return foundDevice
  }

  func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
    guard let device = device else {
      return
    }

    if deviceMatches(device, key: matchKey) {
      foundDevice = device
      isComplete = true
      sender.stop()
    }
  }

  func deviceInquiryComplete(
    _ sender: IOBluetoothDeviceInquiry!,
    error: IOReturn,
    aborted: Bool
  ) {
    isComplete = true
  }
}

func discoverDevice(matching key: String, timeout: TimeInterval) -> IOBluetoothDevice? {
  if let paired = pairedDevice(matching: key) {
    return paired
  }

  let inquiry = BluetoothInquiryHelper(matchKey: key)
  return inquiry.discover(timeout: timeout)
}

func connectToDevice(_ device: IOBluetoothDevice, timeout: TimeInterval) -> Bool {
  if device.isConnected() {
    return true
  }

  let openResult = device.openConnection()
  if openResult != kIOReturnSuccess {
    return false
  }

  let deadline = Date().addingTimeInterval(timeout)
  while Date() < deadline {
    if device.isConnected() {
      return true
    }
    RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.1))
  }

  return device.isConnected()
}

let timeout: TimeInterval = 8
let matchKey = normalizedName(deviceName)

guard
  let device = withStderrSuppressed({
    discoverDevice(matching: matchKey, timeout: timeout)
  })
else {
  FileHandle.standardError.write(
    Data("Bluetooth device '\(deviceName)' not found (paired or discoverable)\n".utf8)
  )
  exit(1)
}

if !withStderrSuppressed({ connectToDevice(device, timeout: timeout) }) {
  FileHandle.standardError.write(
    Data("Failed to connect to '\(deviceName)'. Ensure it is powered on and paired.\n".utf8)
  )
  exit(1)
}

let outputSetDeadline = Date().addingTimeInterval(timeout)
while Date() < outputSetDeadline {
  if setDefaultOutputDevice(named: deviceName) {
    print("\(deviceName) was set to default audio output")
    exit(0)
  }
  RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.2))
}

FileHandle.standardError.write(
  Data("'\(deviceName)' connected but not available as audio output\n".utf8))
exit(1)
