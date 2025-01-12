# Background Mode

Easy-to-use framework keeping your app alive from background.

[![Language](https://img.shields.io/badge/Language-SwiftUI-purple?style=flat-square)](https://img.shields.io/badge/Language-SwiftUI-purple?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)
[![Versions](https://img.shields.io/badge/Versions-14.0-blue?style=flat-square)](https://img.shields.io/badge/Versions-14.0-blue?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding BackgroundMode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/digital-magic-club/background-mode.git", .upToNextMajor(from: "1.0.0"))
]
```

Also, you need to tick the Audio background mode from your App's target `Signing & Capabilities` menu:


## Usage

1. Import the `BackgroundMode` package: `import BackgroundMode`
1. Toggle the `BackgroundMode.shared.keepAlive` to keep your app from working in background or not.

```
import CardPicker

struct ContentView: View {
  @State private var card: Card?

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink("Card Picker", destination: CardPickerView(card: $card))

        if let card {
          Text(card.description)
        }
      }
      .padding()
    }
  }
}
```

## Credits

This project is owned and maintained by the Digital Magic Club. You can join the [Facebook group](https://www.facebook.com/groups/digitalmagicclub) for project updates and releases.

## Sponsorship

The [DMC](https://github.com/sponsors/digital-magic-club) is looking to raise money to officially stay registered as a federal non-profit organization.

Sponsoring the DMC will enable us to:
- Pay our yearly legal fees to keep the non-profit in good status,
- Keep adding more open-source features at a faster pace,
- Potentially fund test servers to make it easier for us to test the edge cases,
- Potentially fund developers to work on one of our projects full-time.

The magic community adoption of the DMC libraries has been amazing!

We are greatly humbled by your enthusiasm around the projects and want to continue to do everything we can to move the needle forward. With your continued support, the DMC will be able to improve its reach and also provide better legal safety for the core members.

Any amount you can donate, whether once or monthly, to help us reach our goal would be greatly appreciated.
