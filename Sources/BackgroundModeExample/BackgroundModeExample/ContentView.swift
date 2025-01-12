//
//  ContentView.swift
//  BackgroundModeExample
//
//  Created by Guillaume Bellut on 12/01/2025.
//  Copyright © 2025 Digital Magic Club. All rights reserved.
//

import SwiftUI
import BackgroundMode

struct ContentView: View {
  @State private var enableBackgroundMode = false
  @State private var enableConsoleLogs = true
  @State private var enableBackgroundTicking = true

  var body: some View {
    VStack {
      Toggle("Background Mode", isOn: $enableBackgroundMode)
        .onChange(of: enableBackgroundMode) { value in
          BackgroundMode.shared.keepAlive = value
        }

      Toggle("Verbose", isOn: $enableConsoleLogs)
        .onChange(of: enableConsoleLogs) { value in
          BackgroundMode.shared.verbose = value
        }

      Toggle("Background Ticking", isOn: $enableBackgroundTicking)
        .onChange(of: enableBackgroundTicking) { value in
          BackgroundMode.shared.playSound = value
        }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
