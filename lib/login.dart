import 'dart:async';

import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:laica_mobile/environments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laica_mobile/utils/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State {
  String document = "";
  String password = "";

  final storage = const FlutterSecureStorage();

  static const homeText = 'Controle de acesso';
  static const userHintText = 'Matrícula ou CPF';
  static const passwordHintText = 'Senha';
  static const primaryColor = 0xFFED2F59;

  var accessFailSnackBar = SnackBar(content: Text('Falha na comunicação com o sistema, tente novamente mais tarde'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);

  Future<bool> _login(String document, String password) async {
    try {
      Token token = await createToken(document, password);

      if (token.jwt != '') {
        await storage.write(key: 'token', value: token.jwt);
        await storage.write(key: 'id', value: token.mobileId);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 55),
                child: const Image(
                  image: AssetImage('assets/images/logo-init.png'),
                  height: 180,
                ),
              ),
              const Text(
                homeText,
                style: TextStyle(
                    color: Color(primaryColor),
                    fontSize: 18.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: userHintText,
                      focusColor: const Color(primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(25.0)
                      )
                  ),
                  onChanged: (text) {
                    setState(() {
                      document = text;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: passwordHintText,
                      focusColor: const Color(primaryColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(25.0)
                      )
                  ),
                  onChanged: (text) {
                    setState(() {
                      password = text;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 65, vertical: 20)),
                  ),
                  onPressed: () async {
                    bool hasLoggedIn = await _login(document, password);

                    if (hasLoggedIn) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Environments(),
                        ),
                      );
                    } else {
                      bool hasConnection = await InternetConnectionChecker().hasConnection;
                      if (hasConnection == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Falha na comunicação com o sistema, tente novamente mais tarde'),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.red.shade400
                            )
                        );
                        Timer(Duration(seconds: 5), () {
                          SystemNavigator.pop();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Falha na conexão, verifique sua internet'),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.red.shade400
                            )
                        );
                        // Timer(Duration(seconds: 5), () {
                        //   SystemNavigator.pop();
                        // });
                      }
                    }
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
