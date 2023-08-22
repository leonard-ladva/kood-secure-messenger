import 'dart:typed_data';

import 'package:cryptography_repository/src/models/keyset.dart';
import 'package:webcrypto/webcrypto.dart';

class CryptographyRepository {
  Future<KeySet> generateKeySet() async {
    //1. Generate keys
    KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair =
        await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    Map<String, dynamic> publicKeyJwk =
        await keyPair.publicKey.exportJsonWebKey();
    Map<String, dynamic> privateKeyJwk =
        await keyPair.privateKey.exportJsonWebKey();

    return KeySet(
      publicKey: publicKeyJwk,
      privateKey: privateKeyJwk,
    );
  }

  Future<Uint8List> deriveCombinedCryptoKey(
    Map<String, dynamic> myPrivateKey,
    Map<String, dynamic> reciverPublicKey,
  ) async {
//1. Reciver's public key
    EcdhPublicKey ecdhPublicKey = await EcdhPublicKey.importJsonWebKey(
        reciverPublicKey, EllipticCurve.p256);
//2. My private key
    EcdhPrivateKey ecdhPrivateKey =
        await EcdhPrivateKey.importJsonWebKey(myPrivateKey, EllipticCurve.p256);

//3. Generating cryptokey called deriveBits
    Uint8List derivedBits = await ecdhPrivateKey.deriveBits(256, ecdhPublicKey);
    return derivedBits;
  }

  final Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);

  Future<String> encrypt(String message, Uint8List combinedCryptoKey) async {
    // 1.
    final aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(combinedCryptoKey);

    // 2.
    List<int> list = message.codeUnits;
    Uint8List data = Uint8List.fromList(list);

    // 3.
    Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(data, iv);

    // 4.
    String encryptedString = String.fromCharCodes(encryptedBytes);
    print('encryptedString $encryptedString');
    return encryptedString;
  }

  Future<String> decrypt(
    String encryptedMessage,
    Uint8List combinedCryptoKey,
  ) async {
    // 1.
    final aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(combinedCryptoKey);

    // 2.
    List<int> message = Uint8List.fromList(encryptedMessage.codeUnits);

    // 3.
    Uint8List decryptedBytes = await aesGcmSecretKey.decryptBytes(message, iv);

    // 4.
    String decryptedString = String.fromCharCodes(decryptedBytes);
    print('decryptedString $decryptedString');
    return decryptedString;
  }
}
