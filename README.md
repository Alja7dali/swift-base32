###### This is an implementation of [Base32](https://en.wikipedia.org/wiki/Base32) `encode`/`decode` algorithm.

#### Example:

```swift
import Base32

/// Encoding to Base32
/// 1. convert string to bytes (utf8 format)
let bytes = "Hello, World!".makeBytes()
/// 2. encode bytes using base32 algorithm
let encodedBytes = Base32.encode(bytes)
/// 3. converting bytes back to string
let encodedString = try String(encoded) // "JBSWY3DPFQQFO33SNRSCC==="


/// Decoding from Base32
/// 1. convert string to bytes (utf8 format)
let bytes = "JBSWY3DPFQQFO33SNRSCC===".makeBytes()
/// 2. decode bytes using base32 algorithm
let decodedBytes = try Base32.decode(bytes)
/// 3. converting bytes back to string
let decodedString = try String(encoded) // "Hello, World!"
```

#### Importing Base32:

To include `Base32` in your project, you need to add the following to the `dependencies` attribute defined in your `Package.swift` file.
```swift
dependencies: [
  .package(url: "https://github.com/alja7dali/swift-base32.git", from: "1.0.0")
]
```