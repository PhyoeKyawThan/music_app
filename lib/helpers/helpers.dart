import 'dart:typed_data';
import 'dart:convert';

Uint8List base64ToUint8List(String base64String) {
  try {
    return base64Decode(base64String);
  } catch (e) {
    print("Error decoding base64: $e");
    return Uint8List(0);
  }
}
