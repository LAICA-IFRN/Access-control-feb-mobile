import 'dart:async';

import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:laica_mobile/environments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laica_mobile/login.dart';
import 'package:laica_mobile/utils/auth.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  final storage = const FlutterSecureStorage();

  _InitState() {
    _verifyAuth();
  }

  _verifyAuth() async {
    var accessFailSnackBar = SnackBar(content: Text('Falha na comunicação com o sistema, tente novamente mais tarde'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }

    bool? isValid = await _checkToken(token!);

    if (isValid == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Environments(),
        ),
      );
    } else {
      bool hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Falha na conexão, verifique sua internet e tente novamente'),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.red.shade400
            )
        );
        Timer(const Duration(seconds: 5), () => SystemNavigator.pop());
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    }
  }

  _checkToken(String token) async {
    try {
      return await verifyToken(token);
    } catch(e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: const Center(
            child: Image(
              image: AssetImage('assets/images/logo-init.png'),
              height: 200,
            ),
          )
      ),
    );
  }
}
