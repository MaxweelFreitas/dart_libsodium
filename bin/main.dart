import 'dart:ffi';
import 'dart:io';

import 'package:dart_libsodium/de/client.dart';
import 'package:dart_libsodium/de/server.dart';
import 'package:dart_libsodium/x_term_color.dart';
import 'package:sodium/sodium.dart';

void main() async {
  // Carrega a DLL do libsodium
  DynamicLibrary loadLibsodium() {
    return DynamicLibrary.open(r'lib\libsodium.dll');
  }

  // Inicializa o Sodium com a DLL carregada
  final sodium = await SodiumInit.init(loadLibsodium);

  // Cria cliente e servidor simulados
  final server = ServerSimulator(sodium);
  final client = SecureClient(sodium);

  // Cliente obtém a chave pública do servidor
  await client.fetchServerPublicKey(server);

  // Mensagem que será enviada
  final message =
      'Mensagem secreta para o servidor com muitos dados...' * 100000;
  print(
    '${XTermColor.magenta}Enviando mensagem: "${message.substring(0, 60)}..."\n',
  );

  final stopwatch = Stopwatch()..start();

  // Cliente encripta e envia mensagem (mas não espera resposta para medir tempo)
  await client.sendEncryptedMessage(
    message,
    server,
    measureOnlyEncryptionAndSend: true,
  );

  stopwatch.stop();
  print(
    '${XTermColor.cyan}Tempo de encriptação + envio: ${XTermColor.main}${stopwatch.elapsedMilliseconds} ms',
  );
  exit(0);
}
