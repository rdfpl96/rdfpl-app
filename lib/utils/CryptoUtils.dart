import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoUtils{
  static String generateHash({
    required String merchantId,
    required String txnId,
    required String totalAmount,
    required String accountNo,
    required String consumerId,
    required String consumerMobileNo,
    required String consumerEmailId,
    required String debitStartDate,
    required String debitEndDate,
    required String maxAmount,
    required String amountType,
    required String frequency,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvvCode,
    required String salt,
    required String hashingAlgorithm, // "SHA1" or "SHA2"
  }) {
    // Concatenate all values in a pipe-separated format
    String dataString = '$merchantId|$txnId|$totalAmount|$accountNo|$consumerId|$consumerMobileNo|'
        '$consumerEmailId|$debitStartDate|$debitEndDate|$maxAmount|$amountType|$frequency|'
        '$cardNumber|$expMonth|$expYear|$cvvCode|$salt';

    print("Hash Values:$dataString");

    // Convert the data string to bytes
    List<int> bytes = utf8.encode(dataString);

    // Hash the data using the specified hashing algorithm
    Digest hash;
    if (hashingAlgorithm.toUpperCase() == 'SHA1') {
      hash = sha1.convert(bytes);
    } else if (hashingAlgorithm.toUpperCase() == 'SHA2') {
      hash = sha512.convert(bytes); // SHA-2 is generally represented by SHA-256
      // hash = sha256.convert(bytes); // SHA-2 is generally represented by SHA-256
      // return encryptedHash(dataString);
    } else {
      throw Exception('Unsupported hashing algorithm: $hashingAlgorithm');
    }

    // Return the hash value as a hexadecimal string
    return hash.toString();
  }

  static String encryptedHash(String dataToHash) {
    // Get SHA-512 digest
    var bytes = utf8.encode(dataToHash); // Convert string to bytes
    Digest sha512Result = sha512.convert(bytes); // Perform the SHA-512 hash

    // Convert the result into a BigInt and then to a hexadecimal string
    BigInt hashBigInt = BigInt.parse(sha512Result.toString(), radix: 16);

    // Convert to hexadecimal string
    String hashText = hashBigInt.toRadixString(16);

    // Ensure the string has a minimum length of 32 (padding with 0s if necessary)
    while (hashText.length < 32) {
      hashText = "0" + hashText;
    }

    return hashText;
  }
}