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

  var body: some View {
    Toggle("Background Mode", isOn: $enableBackgroundMode)
      .onChange(of: enableBackgroundMode) { value in
        BackgroundMode.shared.keepAlive = value
      }
  }
}

#Preview {
  ContentView()
}
