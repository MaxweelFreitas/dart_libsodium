# ⚡ Performance Benchmark using JSON/FlatBuffers with Libsodium Encryption

This project benchmarks the performance of **JSON** and **FlatBuffers**, now with **Libsodium encryption**, focusing on both **writing** ✍️ and **reading** 📖 large datasets. The results include serialization time, encryption/decryption, file writing, and final file sizes 💾.

## 🎯 Objective

To compare how **JSON** and **FlatBuffers** perform when handling **large encrypted datasets**, simulating 1,000,000 records of people 👥. Each record includes a `name` and an `age`.

The comparison is based on:

- ⌛ **Write + Encrypt + Send Data**
- 💾 **Local Write + Encryption Data**
- 🔐 **Read + Decrypt Data**

## 🧱 Code Structure

The code performs the following:

### 1. **📝 JSON**
- Creates a list of people (`name`, `age`)
- Serializes to JSON
- Encrypts the serialized data using **Libsodium**
- Writes it to a file or simulates sending
- Reads and decrypts the data

### 2. **📦 FlatBuffers**
- Creates a list of `Person` objects
- Serializes to binary using **FlatBuffers**
- Encrypts the binary buffer using **Libsodium**
- Writes to a file or simulates sending
- Reads and decrypts the binary data

## ▶️ How to Use

### 1. 🧰 Install Dart

Make sure Dart is installed: [https://dart.dev/get-dart](https://dart.dev/get-dart)

### 2. 📦 Install Dependencies

In your terminal, navigate to the project folder and run:

```bash
dart pub get
```

### 3. 🚀 Run the Benchmarks

```bash
dart run send_data.dart
```

## 📋 Benchmark Results

### 🏗️ Write + Encryption + Send Time

```bash
✅ JSON + Encrypted: Average write (1,000,000 people): 3674.3ms
✅ FlatBuffers + Encrypted: Average write (1,000,000 people): 3064.7ms
```

### 💾 Local Write + Encryption Only

```bash
✅ JSON + Encrypted (local only): Average write: 1676.5ms
✅ FlatBuffers + Encrypted (local only): Average write: 1130.0ms
```

### 🔐 Read + Decryption

```bash
✅ JSON + Decrypted: Average read + decrypt: 803.4ms
✅ FlatBuffers + Decrypted: Average read + decrypt: 100.3ms
```

## ✅ Conclusion

- **FlatBuffers** is consistently faster than **JSON** across all encrypted operations.
- **Encryption** adds overhead to both formats, but FlatBuffers remains efficient.
- **Use FlatBuffers** for performance-critical encrypted data transmission or storage.
- **Use JSON** for ease of use and readability when performance is less critical.

## 📄 License

This project is licensed under the [MIT License](LICENSE).
