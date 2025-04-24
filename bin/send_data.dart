// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_libsodium/de/client.dart';
import 'package:dart_libsodium/de/server.dart';
import 'package:dart_libsodium/pessoa_exemplo_generated.dart' as exemplo;
import 'package:dart_libsodium/x_term_color.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:sodium/sodium.dart';

void main() async {
  DynamicLibrary loadLibsodium() {
    return DynamicLibrary.open(r'lib\libsodium.dll');
  }

  final sodium = await SodiumInit.init(loadLibsodium);
  final client = SecureClient(sodium);
  final server = ServerSimulator(sodium);
  await client.fetchServerPublicKey(server);

  const iterations = 10;
  const totalPessoas = 1000000;
  print(
    '🏗️${XTermColor.limeGreen} Benchmark Aplicando JSON/FlatBuffers Libsodium\n',
  );
  print('📦${XTermColor.cyanBright} Benchmark de Escrita e envio');
  await benchmarkJsonEscrita(iterations, totalPessoas, client, server);
  await benchmarkFlatBuffersEscrita(iterations, totalPessoas, client, server);

  print(
    '🔏${XTermColor.cyanBright} Benchmark de Escrita, Encriptação e Salvamento dos dados\n',
  );
  await Future.delayed(const Duration(milliseconds: 100));
  await benchmarkJsonEscritaCriptografada(iterations, totalPessoas, client);
  await benchmarkFlatBuffersEscritaCriptografada(
    iterations,
    totalPessoas,
    client,
  );

  print('🔓${XTermColor.cyanBright} Benchmark de Leitura com Desencriptação\n');
  await Future.delayed(const Duration(milliseconds: 100));
  await benchmarkJsonLeituraComDesencriptacao(iterations, client);
  await benchmarkFlatBuffersLeituraComDesencriptacao(iterations, client);
}

String formatTime(final double ms) =>
    '(${ms.toStringAsFixed(2)}ms | ${(ms / 1000).toStringAsFixed(2)}s)';

Future<void> benchmarkJsonEscrita(
  final int iterations,
  final int totalPessoas,
  final SecureClient client,
  final ServerSimulator server,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final pessoas = List.generate(
      totalPessoas,
      (final j) => {'nome': 'Pessoa $j', 'idade': 20 + (j % 100)},
    );

    final jsonString = jsonEncode({'pessoas': pessoas});
    await client.sendEncryptedMessage(jsonString, server);

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ JSON + Encriptado: Média de escrita ($totalPessoas pessoas): ${XTermColor.main}${formatTime(avgMs)}',
  );
}

Future<void> benchmarkFlatBuffersEscrita(
  final int iterations,
  final int totalPessoas,
  final SecureClient client,
  final ServerSimulator server,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final builder = fb.Builder(initialSize: 1024 * 1024 * 64);
    final pessoasObjBuilders = List.generate(
      totalPessoas,
      (final j) =>
          exemplo.PessoaObjectBuilder(nome: 'Pessoa $j', idade: 20 + (j % 100)),
    );

    final pessoasOffset = builder.writeList(
      pessoasObjBuilders.map((final e) => e.finish(builder)).toList(),
    );

    builder.startTable(1);
    builder.addOffset(0, pessoasOffset);
    final offset = builder.endTable();
    builder.finish(offset);

    final Uint8List bytes = builder.buffer.sublist(0, builder.offset);
    await client.sendEncryptedMessage(bytes, server, binary: true);

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ FlatBuffers + Encriptado: Média de escrita ($totalPessoas pessoas): ${XTermColor.main}${formatTime(avgMs)}',
  );
}

Future<void> benchmarkJsonEscritaCriptografada(
  final int iterations,
  final int totalPessoas,
  final SecureClient client,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final pessoas = List.generate(
      totalPessoas,
      (final j) => {'nome': 'Pessoa $j', 'idade': 20 + (j % 100)},
    );
    final jsonString = jsonEncode({'pessoas': pessoas});
    final plainBytes = Uint8List.fromList(utf8.encode(jsonString));

    final encryptedData = client.crypto.encryptRawBytes(
      data: plainBytes,
      recipientPublicKey: client.serverPublicKey!,
      senderPrivateKey: client.privateKey,
    );

    final encryptedBytes = Uint8List.fromList([
      ...encryptedData['nonce']!,
      ...encryptedData['cipherText']!,
    ]);

    if (i == iterations - 1) {
      final file = File('output_json_encrypted.bin');
      if (file.existsSync()) file.deleteSync();

      await file.open(mode: FileMode.write).then((final raf) async {
        await raf.writeFrom(encryptedBytes);
        await raf.close();
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ JSON + Encriptado (somente gravação local): Média de escrita ($totalPessoas pessoas): ${XTermColor.main}${formatTime(avgMs)}',
  );
}

Future<void> benchmarkFlatBuffersEscritaCriptografada(
  final int iterations,
  final int totalPessoas,
  final SecureClient client,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final builder = fb.Builder(initialSize: 1024 * 1024 * 64);
    final pessoasObjBuilders = List.generate(
      totalPessoas,
      (final j) =>
          exemplo.PessoaObjectBuilder(nome: 'Pessoa $j', idade: 20 + (j % 100)),
    );

    final pessoasOffset = builder.writeList(
      pessoasObjBuilders.map((final e) => e.finish(builder)).toList(),
    );

    builder.startTable(1);
    builder.addOffset(0, pessoasOffset);
    final offset = builder.endTable();
    builder.finish(offset);

    final plainBytes = builder.buffer.sublist(0, builder.offset);

    final encryptedData = client.crypto.encryptRawBytes(
      data: plainBytes,
      recipientPublicKey: client.serverPublicKey!,
      senderPrivateKey: client.privateKey,
    );

    final encryptedBytes = Uint8List.fromList([
      ...encryptedData['nonce']!,
      ...encryptedData['cipherText']!,
    ]);

    if (i == iterations - 1) {
      final file = File('output_flatbuffers_encrypted.bin');
      if (file.existsSync()) file.deleteSync();

      await file.open(mode: FileMode.write).then((final raf) async {
        await raf.writeFrom(encryptedBytes);
        await raf.close();
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ FlatBuffers + Encriptado (somente gravação local): Média de escrita ($totalPessoas pessoas): ${XTermColor.main}${formatTime(avgMs)}',
  );
}

Future<void> benchmarkJsonLeituraComDesencriptacao(
  final int iterations,
  final SecureClient client,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final file = File('output_json_encrypted.bin');
    final encryptedBytes = file.readAsBytesSync();
    final decrypted = client.decrypt(encryptedBytes);

    final jsonString = utf8.decode(decrypted);
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final List<dynamic> pessoas = decoded['pessoas'];

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ JSON + Decriptado: Média de leitura + desencriptação: ${XTermColor.main}${formatTime(avgMs)}',
  );
}

Future<void> benchmarkFlatBuffersLeituraComDesencriptacao(
  final int iterations,
  final SecureClient client,
) async {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final file = File('output_flatbuffers_encrypted.bin');
    final encryptedBytes = file.readAsBytesSync();
    final decrypted = client.decrypt(encryptedBytes);

    final wrapper = exemplo.PessoasWrapper(decrypted);
    final total = wrapper.pessoas?.length ?? 0;

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  final avgMs = totalTime / iterations;
  print(
    '✅ FlatBuffers + Decriptado: Média de leitura + desencriptação: ${XTermColor.main}${formatTime(avgMs)}',
  );
}
