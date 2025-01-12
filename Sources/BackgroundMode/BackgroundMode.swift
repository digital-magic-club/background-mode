//
//  BackgroundMode.swift
//  BackgroundMode
//
//  Created by Guillaume Bellut on 12/01/2025.
//  Copyright © 2025 Digital Magic Club. All rights reserved.
//

import UIKit

typealias BackgroundTaskName = String

public final class BackgroundMode: NSObject {
  private var tasks = [BackgroundTaskName: UIBackgroundTaskIdentifier]()
  private let defaultTaskInterval: TimeInterval = 10
  private let defaultTaskName: BackgroundTaskName = "backgroundPrivateTask"
  private var defaultTaskCount = 0
  private var defaultTaskRefreshTimer: Timer?

  public static let shared = BackgroundMode()

  public var keepAlive = false {
    didSet {
      guard oldValue != keepAlive else {
        return
      }

      keepAlive ? startBackgroundProcesses() : stopBackgroundProcesses()
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
    tasks[name] = UIApplication.shared.beginBackgroundTask(withName: name) {
      print("Oh no: \(name) has been killed!")
      expirationHandler?()
    }

    print("Started \(name)")
    print("Remaining time for background tasks: \(UIApplication.shared.backgroundTimeRemaining)")
  }

  func stop(_ name: BackgroundTaskName) {
    guard let id = identifier(for: name) else {
      return
    }

    UIApplication.shared.endBackgroundTask(id)
    print("Ended \(name) with success!")

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
  }

  func stopBackgroundProcesses() {
    stopEndlessBackgroundTask()
  }

  func startEndlessBackgroundTask() {
    defaultTaskRefreshTimer = Timer.scheduledTimer(withTimeInterval: defaultTaskInterval, repeats: true) { _ in
      self.createNewDefaultBackgroundTask()
    }

    self.createNewDefaultBackgroundTask()

    print("Started preventing from sleeping")
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

    print("Stopped preventing from sleeping")
  }
}
