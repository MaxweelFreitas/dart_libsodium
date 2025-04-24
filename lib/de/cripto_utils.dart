import 'dart:typed_data';

import 'package:sodium/sodium.dart';

class CryptoUtils {
  final Sodium sodium;

  CryptoUtils(this.sodium);

  Uint8List uint8ListFromSecureKey(final SecureKey key) {
    return key.extractBytes();
  }

  SecureKey secureKeyFromUint8List(final Uint8List bytes) {
    return sodium.secureCopy(bytes);
  }

  Uint8List extractPublicKey(final KeyPair keyPair) {
    return keyPair.publicKey;
  }

  Map<String, Uint8List> encryptRawBytes({
    required final Uint8List data,
    required final Uint8List recipientPublicKey,
    required final SecureKey senderPrivateKey,
  }) {
    final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);
    final cipherText = sodium.crypto.box.easy(
      message: data,
      nonce: nonce,
      publicKey: recipientPublicKey,
      secretKey: senderPrivateKey,
    );

    return {'nonce': nonce, 'cipherText': cipherText};
  }

  Uint8List decryptRawBytes({
    required final Uint8List cipherText,
    required final Uint8List nonce,
    required final Uint8List senderPublicKey,
    required final SecureKey recipientPrivateKey,
  }) {
    return sodium.crypto.box.openEasy(
      cipherText: cipherText,
      nonce: nonce,
      publicKey: senderPublicKey,
      secretKey: recipientPrivateKey,
    );
  }

  String decryptMessage({
    required final Uint8List cipherText,
    required final Uint8List nonce,
    required final Uint8List senderPublicKey,
    required final SecureKey recipientPrivateKey,
  }) {
    final decrypted = sodium.crypto.box.openEasy(
      cipherText: cipherText,
      nonce: nonce,
      publicKey: senderPublicKey,
      secretKey: recipientPrivateKey,
    );
    return String.fromCharCodes(decrypted);
  }

  Map<String, Uint8List> encryptMessage({
    required final String message,
    required final Uint8List recipientPublicKey,
    required final SecureKey senderPrivateKey,
  }) {
    final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);
    final messageBytes = Uint8List.fromList(message.codeUnits);

    final cipherText = sodium.crypto.box.easy(
      message: messageBytes,
      nonce: nonce,
      publicKey: recipientPublicKey,
      secretKey: senderPrivateKey,
    );

    return {'nonce': nonce, 'cipherText': cipherText};
  }
}
