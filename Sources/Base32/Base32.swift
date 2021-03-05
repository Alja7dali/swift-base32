/// Encodes and Decodes bytes using the 
/// Base32 algorithm
///
/// https://en.wikipedia.org/wiki/Base32

// Note: The implementation has 3 different attempts,
//       the last attempt is the fastest. The previous
//       two are there just as reference..

/// Maps binary format to base32 encoding
private let Base32EncodingTable: [Byte: Byte] = [
   0: .A,      1: .B,     2: .C,     3: .D,
   4: .E,      5: .F,     6: .G,     7: .H,
   8: .I,      9: .J,    10: .K,    11: .L,
  12: .M,     13: .N,    14: .O,    15: .P,
  16: .Q,     17: .R,    18: .S,    19: .T,
  20: .U,     21: .V,    22: .W,    23: .X,
  24: .Y,     25: .Z,    26: .two,  27: .three,
  28: .four,  29: .five, 30: .six,  31: .seven
]

private let encode: (Byte) -> Byte = {
  Base32EncodingTable[$0] ?? .max
}

/// Maps base32 encoding to binary format
private let Base32DecodingTable: [Byte: Byte] = [
   .A: 0,     .B: 1,     .C: 2,        .D: 3,
   .E: 4,     .F: 5,     .G: 6,        .H: 7,
   .I: 8,     .J: 9,     .K: 10,       .L: 11,
   .M: 12,    .N: 13,    .O: 14,       .P: 15,
   .Q: 16,    .R: 17,    .S: 18,       .T: 19,
   .U: 20,    .V: 21,    .W: 22,       .X: 23,
   .Y: 24,    .Z: 25,  .two: 26,   .three: 27,
.four: 28, .five: 29,  .six: 30,   .seven: 31
]

private let decode: (Byte) -> Byte = {
  Base32DecodingTable[$0] ?? .max
}

public func encode(_ bytes: Bytes) -> Bytes {

  var result = Bytes()

  for byteIndex in stride(from: 0, to: bytes.count, by: 5) {
    let maxOffset = (byteIndex + 5 >= bytes.count) ? bytes.count : byteIndex + 5
    var numberOfBytes = maxOffset - byteIndex

    var byte = Bytes(repeating: 0, count: 5)
    var encodedByte = Bytes(repeating: .equals, count: 8)

    //// Attempt: I
    // while numberOfBytes > 0 {
    //     switch numberOfBytes {
    //     case 5:
    //         byte[4] = bytes[byteIndex + 4]
    //         encodedByte[7] = encode( byte[4] & 0x1F )
    //     case 4:
    //         byte[3] = bytes[byteIndex + 3]
    //         encodedByte[6] = encode( ((byte[3] << 3) & 0x18) | ((byte[4] >> 5) & 0x07) )
    //         encodedByte[5] = encode( ((byte[3] >> 2) & 0x1F) )
    //     case 3:
    //         byte[2] = bytes[byteIndex + 2]
    //         encodedByte[4] = encode( ((byte[2] << 1) & 0x1E) | ((byte[3] >> 7) & 0x01) )
    //     case 2:
    //         byte[1] = bytes[byteIndex + 1]
    //         encodedByte[2] = encode( ((byte[1] >> 1) & 0x1F) )
    //         encodedByte[3] = encode( ((byte[1] << 4) & 0x10) | ((byte[2] >> 4) & 0x0F) )
    //     case 1:
    //         byte[0] = bytes[byteIndex + 0]
    //         encodedByte[0] = encode( ((byte[0] >> 3) & 0x1F) )
    //         encodedByte[1] = encode( ((byte[0] << 2) & 0x1C) | ((byte[1] >> 6) & 0x03) )
    //     default:
    //         break
    //     }
    //     numberOfBytes -= 1
    // }

    //// Attempt: II
    // while numberOfBytes > 0 {
    //     switch numberOfBytes {
    //     case 5:
    //         byte[4] = bytes[byteIndex + 4]
    //         encodedByte[7] = encode( byte[4] & 0x1F )
    //     case 4:
    //         byte[3] = bytes[byteIndex + 3]

    //         let b = [(byte[3] << 3) & 0x18, (byte[4] >> 5) & 0x07, (byte[3] >> 2) & 0x1F]
    //         encodedByte[6] = encode( b[0] | b[1] )
    //         encodedByte[5] = encode( b[2] )
    //     case 3:
    //         byte[2] = bytes[byteIndex + 2]

    //         let b = [(byte[2] << 1) & 0x1E, (byte[3] >> 7) & 0x01]
    //         encodedByte[4] = encode( b[0] | b[1] )
    //     case 2:
    //         byte[1] = bytes[byteIndex + 1]

    //         let b = [(byte[1] >> 1) & 0x1F, (byte[1] << 4) & 0x10, (byte[2] >> 4) & 0x0F]
    //         encodedByte[2] = encode( b[0] )
    //         encodedByte[3] = encode( b[1] | b[2] )
    //     case 1:
    //         byte[0] = bytes[byteIndex + 0]

    //         let b = [(byte[0] >> 3) & 0x1F, (byte[0] << 2) & 0x1C, (byte[1] >> 6) & 0x03]
    //         encodedByte[0] = encode( b[0] )
    //         encodedByte[1] = encode( b[1] | b[2] )
    //     default:
    //         break
    //     }
    //     numberOfBytes -= 1
    // }

    // Attempt: III
    while numberOfBytes > 0 {
      switch numberOfBytes {
      case 5:
        byte[4] = bytes[byteIndex + 4]
        encodedByte[7] = encode( byte[4] & 0x1F )
      case 4:
        byte[3] = bytes[byteIndex + 3]

        let b1 = (byte[3] << 3) & 0x18
        let b2 = (byte[4] >> 5) & 0x07
        let b3 = (byte[3] >> 2) & 0x1F
        encodedByte[6] = encode( b1 | b2 )
        encodedByte[5] = encode( b3 )
      case 3:
        byte[2] = bytes[byteIndex + 2]

        let b1 = (byte[2] << 1) & 0x1E
        let b2 = (byte[3] >> 7) & 0x01
        encodedByte[4] = encode( b1 | b2 )
      case 2:
        byte[1] = bytes[byteIndex + 1]

        let b1 = (byte[1] >> 1) & 0x1F
        let b2 = (byte[1] << 4) & 0x10
        let b3 = (byte[2] >> 4) & 0x0F
        encodedByte[2] = encode( b1 )
        encodedByte[3] = encode( b2 | b3 )
      case 1:
        byte[0] = bytes[byteIndex + 0]

        let b1 = (byte[0] >> 3) & 0x1F
        let b2 = (byte[0] << 2) & 0x1C
        let b3 = (byte[1] >> 6) & 0x03
        encodedByte[0] = encode( b1 )
        encodedByte[1] = encode( b2 | b3 )
      default:
        break
      }
      numberOfBytes -= 1
    }

    result += encodedByte
  }

  return result
}


public enum Base32DecodingError: Error {
  case oddLength
  case invalidByte(Byte)
}

public func decode(_ bytes: Bytes) throws -> Bytes {

  guard bytes.count % 2 == 0 else {
    throw Base32DecodingError.oddLength
  }

  var temp = Bytes()

  for byte in bytes.uppercased {
    if Base32DecodingTable[byte] != nil {
      temp.append(byte)
    } else if byte != .equals {
      throw Base32DecodingError.invalidByte(byte)
    }
  }

  var result = Bytes()

  for byteIndex in stride(from: 0, to: temp.count, by: 8) {
    let maxOffset = (byteIndex + 8 >= temp.count) ? temp.count : byteIndex + 8
    var numberOfBytes = maxOffset - byteIndex

    var encodedByte = Bytes(repeating: 0, count: 8)

    while numberOfBytes > 0 {
      switch numberOfBytes {
      case 8: encodedByte[7] = decode( temp[byteIndex + 7] )
      case 7: encodedByte[6] = decode( temp[byteIndex + 6] )
      case 6: encodedByte[5] = decode( temp[byteIndex + 5] )
      case 5: encodedByte[4] = decode( temp[byteIndex + 4] )
      case 4: encodedByte[3] = decode( temp[byteIndex + 3] )
      case 3: encodedByte[2] = decode( temp[byteIndex + 2] )
      case 2: encodedByte[1] = decode( temp[byteIndex + 1] )
      case 1: encodedByte[0] = decode( temp[byteIndex + 0] )
      default: break
      }
      numberOfBytes -= 1
    }

    // // Attempt: I
    // result.append(((encodedByte[0] << 3) & 0xF8) | ((encodedByte[1] >> 2) & 0x07))
    // result.append(((encodedByte[1] << 6) & 0xC0) | ((encodedByte[2] << 1) & 0x3E) | ((encodedByte[3] >> 4) & 0x01))
    // result.append(((encodedByte[3] << 4) & 0xF0) | ((encodedByte[4] >> 1) & 0x0F))
    // result.append(((encodedByte[4] << 7) & 0x80) | ((encodedByte[5] << 2) & 0x7C) | ((encodedByte[6] >> 3) & 0x03))
    // result.append(((encodedByte[6] << 5) & 0xE0) | (encodedByte[7] & 0x1F))

    //// Attempt: II
    // var b = [(encodedByte[0] << 3) & 0xF8, (encodedByte[1] >> 2) & 0x07]
    // result.append(b[0] | b[1])
    // b = [(encodedByte[1] << 6) & 0xC0, (encodedByte[2] << 1) & 0x3E, (encodedByte[3] >> 4) & 0x01]
    // result.append(b[0] | b[1] | b[2])
    // b = [(encodedByte[3] << 4) & 0xF0, (encodedByte[4] >> 1) & 0x0F]
    // result.append(b[0] | b[1])
    // b = [(encodedByte[4] << 7) & 0x80, (encodedByte[5] << 2) & 0x7C, (encodedByte[6] >> 3) & 0x03]
    // result.append(b[0] | b[1] | b[2])
    // b = [(encodedByte[6] << 5) & 0xE0, (encodedByte[7] & 0x1F)]
    // result.append(b[0] | b[1])

    // Attempt: III
    let b01 = (encodedByte[0] << 3) & 0xF8
    let b02 = (encodedByte[1] >> 2) & 0x07
    result.append(b01 | b02)
    let b11 = (encodedByte[1] << 6) & 0xC0
    let b12 = (encodedByte[2] << 1) & 0x3E
    let b13 = (encodedByte[3] >> 4) & 0x01
    result.append(b11 | b12 | b13)
    let b21 = (encodedByte[3] << 4) & 0xF0
    let b22 = (encodedByte[4] >> 1) & 0x0F
    result.append(b21 | b22)
    let b31 = (encodedByte[4] << 7) & 0x80
    let b32 = (encodedByte[5] << 2) & 0x7C
    let b33 = (encodedByte[6] >> 3) & 0x03
    result.append(b31 | b32 | b33)
    let b41 = (encodedByte[6] << 5) & 0xE0
    let b42 = (encodedByte[7] & 0x1F)
    result.append(b41 | b42)
  }

  while result.last == 0 {
    result.removeLast()
  }
  return result
}