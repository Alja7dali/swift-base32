import XCTest
@testable import Base32

final class Base32Tests: XCTestCase {
  func testEncodingToBase32() {
    do {
      let bytes = "Hello, World!".makeBytes()
      let encoded = Base32.encode(bytes)
      let str = try String(encoded)
      XCTAssertEqual(str, "JBSWY3DPFQQFO33SNRSCC===")
    } catch {
      XCTFail()
    }
  }

  func testDecodingToBase32() {
    do {
      let bytes = "JBSWY3DPFQQFO33SNRSCC===".makeBytes()
      let decoded = try Base32.decode(bytes)
      let str = try String(decoded)
      XCTAssertEqual(str, "Hello, World!")
    } catch {
      XCTFail()
    }
  }

  static var allTests = [
    ("testEncodingToBase32", testEncodingToBase32),
    ("testDecodingToBase32", testDecodingToBase32),
  ]
}