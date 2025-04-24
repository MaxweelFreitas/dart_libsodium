import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

import '../x_term_color.dart';
import 'cripto_utils.dart';

class ServerSimulator {
  final Sodium sodium;
  final CryptoUtils crypto;
  late Uint8List publicKey;
  late SecureKey privateKey;
  final bool verbose;

  ServerSimulator(this.sodium, {this.verbose = false})
    : crypto = CryptoUtils(sodium) {
    final keyPair = sodium.crypto.box.keyPair();
    publicKey = keyPair.publicKey;
    privateKey = keyPair.secretKey;
  }

  Future<Uint8List> getPublicKey() async {
    return publicKey;
  }

  Future<String> receiveMessage(
    final String encryptedMessage,
    final Uint8List clientPublicKeyBytes,
  ) async {
    if (verbose) {
      print(
        '[SERVIDOR] Recebido encriptado do client (base64): $encryptedMessage',
      );
    }

    final clientPublicKey = clientPublicKeyBytes;
    final receivedBytes = base64Decode(encryptedMessage);
    final nonce = receivedBytes.sublist(0, sodium.crypto.box.nonceBytes);
    final cipherText = receivedBytes.sublist(sodium.crypto.box.nonceBytes);

    final decrypted = crypto.decryptMessage(
      cipherText: cipherText,
      nonce: nonce,
      senderPublicKey: clientPublicKey,
      recipientPrivateKey: privateKey,
    );

    final responseMessage = decrypted;

    final responseData = crypto.encryptMessage(
      message: responseMessage,
      recipientPublicKey: clientPublicKey,
      senderPrivateKey: privateKey,
    );

    final dataToSend = Uint8List.fromList([
      ...responseData['nonce']!,
      ...responseData['cipherText']!,
    ]);

    if (verbose) {
      print(
        '${XTermColor.magenta}[SERVIDOR] Enviando dados encriptados (base64):${XTermColor.reset} ${base64Encode(dataToSend)}',
      );
    }

    return base64Encode(dataToSend);
  }

  Future<void> receiveEncryptedMessage(
    final Uint8List message, {
    final bool binary = false,
  }) async {
    final file = File(
      binary ? 'output_flatbuffers_encrypted.bin' : 'output_json_encrypted.bin',
    );
    await file.writeAsBytes(message);
  }
}
