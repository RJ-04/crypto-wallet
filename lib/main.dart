import 'package:crypto_wallet/ui/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA7betf9wc3YVaI3CP7fI4CYM3TdfOY4BU",
        authDomain: "crypto-b1239.firebaseapp.com",
        projectId: "crypto-b1239",
        storageBucket: "crypto-b1239.appspot.com",
        messagingSenderId: "919758425593",
        appId: "1:919758425593:web:56d458a3ff32a9b9978128",
        measurementId: "G-M3GT4NQPKN",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Crypto',
      home: Authentication(),
    );
  }
}
