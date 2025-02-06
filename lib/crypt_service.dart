import 'package:encrypt/encrypt.dart' as encrypt;

class CryptService {
  static String _normalizeKey(String key) {
    if (key.length >= 32) return key.substring(0, 32); // Trim to 32 bytes
    return key.padRight(32, ' '); // Pad to 32 bytes
  }

  static String encryptText(String text, String key) {
    final keyBytes = encrypt.Key.fromUtf8(_normalizeKey(key));
    final iv = encrypt.IV.fromUtf8('1234567890123456'); // Fixed IV
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText, String key) {
    final keyBytes = encrypt.Key.fromUtf8(_normalizeKey(key));
    final iv = encrypt.IV.fromUtf8('1234567890123456');
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    try {
      return encrypter.decrypt64(encryptedText, iv: iv);
    } catch (e) {
      return 'Invalid Key or Encrypted Text';
    }
  }
}
