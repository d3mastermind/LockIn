class CryptService {
  // XOR-based encryption
  static String _xorEncrypt(String plaintext, String key) {
    String encrypted = "";
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
      encrypted += String.fromCharCode(charCode);
    }
    return encrypted;
  }

  // Base62 encoding
  static String _base62Encode(String input) {
    const String base62Chars =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    final List<int> bytes = input.codeUnits;
    BigInt number = BigInt.zero;
    for (int byte in bytes) {
      number = (number << 8) + BigInt.from(byte);
    }
    String encoded = "";
    while (number > BigInt.zero) {
      encoded = base62Chars[(number % BigInt.from(62)).toInt()] + encoded;
      number = number ~/ BigInt.from(62);
    }
    return encoded.isEmpty ? "0" : encoded;
  }

  // Base62 decoding
  static String _base62Decode(String input) {
    const String base62Chars =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    BigInt number = BigInt.zero;
    for (int i = 0; i < input.length; i++) {
      number =
          number * BigInt.from(62) + BigInt.from(base62Chars.indexOf(input[i]));
    }
    List<int> bytes = [];
    while (number > BigInt.zero) {
      bytes.insert(0, (number % BigInt.from(256)).toInt());
      number = number ~/ BigInt.from(256);
    }
    return String.fromCharCodes(bytes);
  }

  // Encrypt and encode to Base62
  static String encrypt(String plaintext, String key) {
    String encrypted = _xorEncrypt(plaintext, key);
    return _base62Encode(encrypted);
  }

  // Decode from Base62 and decrypt
  static String decrypt(String encrypted, String key) {
    String decoded = _base62Decode(encrypted);
    return _xorEncrypt(decoded, key);
  }
}
