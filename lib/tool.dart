library dart_firebase.tool;

import 'dart:io';
import 'dart:convert';

import 'api.dart';
export 'api.dart';

const List<String> _emailEnvVars = const <String>[
  "FIREBASE_EMAIL",
  "FIREBASE_USERNAME",
  "FIREBASE_USER"
];

const List<String> _passwordEnvVars = const <String>[
  "FIREBASE_PASSWORD",
  "FIREBASE_PASS",
  "FIREBASE_PWD"
];

String? _getEnvKey(List<String> possible) {
  for (var key in possible) {
    var dartEnvValue = new String.fromEnvironment(key);
    if (dartEnvValue != null) {
      return dartEnvValue;
    }

    if (Platform.environment.containsKey(key) &&
        Platform.environment[key]!.isNotEmpty) {
      return Platform.environment[key];
    }
  }

  throw new Exception(
      "Expected environment variable '${possible.first}' to be present.");
}

FirestoreClient getFirestoreClient(
    {String? firebaseUsername,
    String? firebasePassword,
    App? app,
    FirestoreApiEndpoints? endpoints}) {
  var email = firebaseUsername ?? _getEnvKey(_emailEnvVars)!.trim();
  var password = firebasePassword ?? _getEnvKey(_passwordEnvVars)!;

  if (password.startsWith("base64:")) {
    password =
        const Utf8Decoder().convert(const Base64Decoder().convert(password, 7));
  }

  if (password.endsWith("\n")) {
    password = password.substring(0, password.length - 1);
  }

  return new FirestoreClient(email, password, app, endpoints: endpoints);
}
