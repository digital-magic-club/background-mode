//
//  BackgroundMode.swift
//  BackgroundMode
//
//  Created by Guillaume Bellut on 12/01/2025.
//  Copyright © 2025 Digital Magic Club. All rights reserved.
//

import UIKit
import AVKit

typealias BackgroundTaskName = String

public final class BackgroundMode: NSObject {
  private var tasks = [BackgroundTaskName: UIBackgroundTaskIdentifier]()
  private let defaultTaskInterval: TimeInterval = 10
  private let defaultTaskName: BackgroundTaskName = "backgroundPrivateTask"
  private var defaultTaskCount = 0
  private var defaultTaskRefreshTimer: Timer?
  private var audioPlayer: AVAudioPlayer?

  public static let shared = BackgroundMode()

  public var keepAlive = false {
    didSet {
      guard oldValue != keepAlive else {
        return
      }

      keepAlive ? startBackgroundProcesses() : stopBackgroundProcesses()
    }
  }

  // To enable / disable the console logs
  public var verbose = true

  // Playing a background sound will make sure the app can't be killed by iOS
  // Disabling the sound (a "tick" every ~15s) will not assure this framework keeps working as expected!
  public var playSound = true {
    didSet {
      if keepAlive {
        playSound ? startBackgroundSound() : stopBackgroundSound()
      }
    }
  }

  override private init() {
    print("Shared Background Mode Manager instance created")
  }
}

// MARK: - Private

private extension BackgroundMode {
  var hasBackgroundTaskStarted: Bool {
    for key in tasks.keys where identifier(for: key) != .invalid {
      return true
    }

    return false
  }

  func start(_ name: BackgroundTaskName, expirationHandler: (() -> Void)? = nil) {
    tasks[name] = UIApplication.shared.beginBackgroundTask(withName: name) { [weak self] in
      if self?.verbose == true {
        print("Oh no: \(name) has been killed!")
      }
      expirationHandler?()
    }

    if verbose {
      print("Started \(name)")
      print("Remaining time for background tasks: \(UIApplication.shared.backgroundTimeRemaining)")
    }
  }

  func stop(_ name: BackgroundTaskName) {
    guard let id = identifier(for: name) else {
      return
    }

    UIApplication.shared.endBackgroundTask(id)
    if verbose {
      print("Ended \(name) with success!")
    }

    tasks.removeValue(forKey: name)
  }

  func identifier(for name: BackgroundTaskName) -> UIBackgroundTaskIdentifier? {
    guard let id = tasks[name] else {
      return nil
    }

    return id
  }

  func startBackgroundProcesses() {
    startEndlessBackgroundTask()
    startBackgroundSound()
  }

  func stopBackgroundProcesses() {
    stopEndlessBackgroundTask()
    stopBackgroundSound()
  }

  func startEndlessBackgroundTask() {
    defaultTaskRefreshTimer = Timer.scheduledTimer(withTimeInterval: defaultTaskInterval, repeats: true) { _ in
      self.createNewDefaultBackgroundTask()
    }

    self.createNewDefaultBackgroundTask()

    if verbose {
      print("Started preventing from sleeping")
    }
  }

  func createNewDefaultBackgroundTask() {
    defaultTaskCount += 1
    start(defaultTaskName + String(defaultTaskCount))

    if defaultTaskCount > 1 {
      stop(defaultTaskName + String(defaultTaskCount - 1))
    }
  }

  func stopEndlessBackgroundTask() {
    defaultTaskRefreshTimer?.invalidate()
    defaultTaskRefreshTimer = nil

    stop(defaultTaskName + String(defaultTaskCount))
    defaultTaskCount = 0

    if verbose {
      print("Stopped preventing from sleeping")
    }
  }

  private func startBackgroundSound() {
    guard let url = Bundle.module.url(forResource: "22kHz__15_second_Tone", withExtension: "mp3") else {
      if verbose {
        print("Couldn't find background sound file")
      }
      return
    }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
      try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
    } catch let error {
      if verbose {
        print("Error while starting background sound: \(error.localizedDescription)")
      }
    }

    guard let player = audioPlayer else {
      if verbose {
        print("Trying to start background sound but no player found")
      }
      return
    }

    player.numberOfLoops = -1
    player.play()

    if verbose {
      print("Playing background sound")
    }
  }

  private func stopBackgroundSound() {
    guard let player = audioPlayer else {
      if verbose {
        print("Trying to stop background sound but no player found")
      }
      return
    }

    player.stop()
    if verbose {
      print("Stopped background sound")
    }
  }

}
