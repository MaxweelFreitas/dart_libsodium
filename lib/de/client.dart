import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

import '../x_term_color.dart';
import 'cripto_utils.dart';
import 'server.dart';

class SecureClient {
  final Sodium sodium;
  final CryptoUtils crypto;
  late Uint8List publicKey;
  late SecureKey privateKey;
  Uint8List? serverPublicKey;
  final bool verbose;

  SecureClient(this.sodium, {this.verbose = false})
    : crypto = CryptoUtils(sodium) {
    final keyPair = sodium.crypto.box.keyPair();
    publicKey = keyPair.publicKey;
    privateKey = keyPair.secretKey;
  }

  Future<void> fetchServerPublicKey(final ServerSimulator server) async {
    final publicKeyBytes = await server.getPublicKey();
    serverPublicKey = publicKeyBytes;
  }

  Future<dynamic> sendEncryptedMessage(
    final dynamic message,
    final ServerSimulator server, {
    final bool binary = false,
    final bool measureOnlyEncryptionAndSend = false,
  }) async {
    if (serverPublicKey == null) {
      await fetchServerPublicKey(server);
    }

    Uint8List plainBytes;

    if (binary) {
      if (message is! Uint8List) {
        throw ArgumentError('Mensagem binária deve ser Uint8List');
      }
      plainBytes = message;
    } else {
      plainBytes = Uint8List.fromList(utf8.encode(message.toString()));
    }

    final encryptedData = crypto.encryptRawBytes(
      data: plainBytes,
      recipientPublicKey: serverPublicKey!,
      senderPrivateKey: privateKey,
    );

    final dataToSend = Uint8List.fromList([
      ...encryptedData['nonce']!,
      ...encryptedData['cipherText']!,
    ]);

    if (verbose) {
      print(
        '${XTermColor.yellowBright}[CLIENTE] Enviando dados encriptados (base64):${XTermColor.reset} ${base64Encode(dataToSend)}',
      );
    }

    if (measureOnlyEncryptionAndSend) {
      await server.receiveMessage(base64Encode(dataToSend), publicKey);
      return '';
    }

    final response = await server.receiveMessage(
      base64Encode(dataToSend),
      publicKey,
    );

    final responseBytes = base64Decode(response);
    final responseNonce = responseBytes.sublist(
      0,
      sodium.crypto.box.nonceBytes,
    );
    final responseCipherText = responseBytes.sublist(
      sodium.crypto.box.nonceBytes,
    );

    if (verbose) {
      print('[CLIENTE] Recebido encriptado do server (base64): $response');
    }

    final decrypted = crypto.decryptRawBytes(
      cipherText: responseCipherText,
      nonce: responseNonce,
      senderPublicKey: serverPublicKey!,
      recipientPrivateKey: privateKey,
    );

    if (binary) {
      return decrypted;
    } else {
      return utf8.decode(decrypted);
    }
  }

  /// Descriptografa uma mensagem encriptada (com nonce embutido no início)
  Uint8List decrypt(final Uint8List encryptedMessage) {
    final nonceSize = sodium.crypto.box.nonceBytes;
    final nonce = encryptedMessage.sublist(0, nonceSize);
    final cipherText = encryptedMessage.sublist(nonceSize);

    final decrypted = crypto.decryptRawBytes(
      cipherText: cipherText,
      nonce: nonce,
      senderPublicKey: serverPublicKey!,
      recipientPrivateKey: privateKey,
    );

    return decrypted;
  }
}
