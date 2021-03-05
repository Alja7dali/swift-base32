// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "Base32",
  products: [
    .library(name: "Base32", targets: ["Base32"]),
  ],
  dependencies: [
    .package(url: "https://github.com/alja7dali/swift-bits", from: "1.0.0"),
  ],
  targets: [
    .target(name: "Base32", dependencies: ["Bits"]),
    .testTarget(name: "Base32Tests", dependencies: ["Base32"]),
  ]
)
