# Lock In - AES Encryption App

Lock In is a Flutter application that provides a simple interface for encrypting and decrypting text using AES (Advanced Encryption Standard) encryption in CBC (Cipher Block Chaining) mode.

[![Flutter](https://img.shields.io/badge/Flutter-2.0+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Quick Start

- 📱 [Download APK](https://github.com/d3mastermind/LockIn/blob/ac9e79f1b63cea27fa6f040ae8352f20bc740088/APK/app-release.apk)
- 🎮 [Try Live Demo](https://appetize.io/app/b_zgb7ifmtdv433tcxtzvwna3kfu)


## Features

- Text encryption using AES-256 in CBC mode
- Text decryption with error handling
- User-friendly interface with light/dark mode
- Copy functionality for encrypted/decrypted text
- Input validation and error handling

## Encryption Implementation

The app uses the `encrypt` package to implement AES encryption. Here's how the `CryptService` works:

### Key Handling

```dart
static String _normalizeKey(String key) {
    if (key.length >= 32) return key.substring(0, 32);
    return key.padRight(32, ' ');
}
```

- Keys are normalized to exactly 32 bytes (256 bits)
- If the key is longer than 32 bytes, it's truncated
- If shorter, it's padded with spaces

### Encryption Process

```dart
static String encryptText(String text, String key) {
    final keyBytes = encrypt.Key.fromUtf8(_normalizeKey(key));
    final iv = encrypt.IV.fromUtf8('1234567890123456');
    final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc)
    );

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
}
```

1. The key is normalized to 32 bytes
2. A fixed Initialization Vector (IV) is used
3. An AES encrypter is created in CBC mode
4. The text is encrypted and returned as a base64 string

### Decryption Process

```dart
static String decryptText(String encryptedText, String key) {
    final keyBytes = encrypt.Key.fromUtf8(_normalizeKey(key));
    final iv = encrypt.IV.fromUtf8('1234567890123456');
    final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc)
    );

    try {
        return encrypter.decrypt64(encryptedText, iv: iv);
    } catch (e) {
        return 'Invalid Key or Encrypted Text';
    }
}
```

1. Uses the same key normalization and IV
2. Attempts to decrypt the base64-encoded text
3. Returns an error message if decryption fails

## Example Usage

### Encryption Example

```dart
String plaintext = "Hello, World!";
String key = "MySecretKey123";
String encrypted = CryptService.encryptText(plaintext, key);
// Output: "YW5kb21FbmNyeXB0ZWRTdHJpbmc=" (example output)
```

### Decryption Example

```dart
String encryptedText = "YW5kb21FbmNyeXB0ZWRTdHJpbmc=";
String key = "MySecretKey123";
String decrypted = CryptService.decryptText(encryptedText, key);
// Output: "Hello, World!"
```

## Security Considerations

- The app uses a fixed IV for simplicity. In a production environment, you should use a random IV for each encryption
- The key padding mechanism is basic. Consider using a more secure key derivation function for production use

## Installation

1. Clone the repository:
```bash
git clone https://github.com/d3mastermind/LockIn.git
```

2. Navigate to the project directory:
```bash
cd LockIn
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## Links

- [Flutter Documentation](https://flutter.dev/docs)
- [encrypt package](https://pub.dev/packages/encrypt)