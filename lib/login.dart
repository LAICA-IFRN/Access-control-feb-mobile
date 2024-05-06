import 'dart:async';
import 'package:flutter/services.dart';
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
  static const userHintText = 'Documento';
  static const passwordHintText = 'Senha';
  static const primaryColor = 0xFFED2F59;
  var _showPassword = true;
  var _loginFailFeedback = false;
  var _loginFailStatusCode = 0;

  var accessFailSnackBar = SnackBar(content: Text('Falha na comunicação com o sistema, tente novamente mais tarde'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);
  var userNotFoundSnackBar = SnackBar(content: Text('Usuário não encontrado, digitou o documento correto?'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);
  var invalidPasswordSnackBar = SnackBar(content: Text('Senha incorreta, tente novamente'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);

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
    } on CreateTokenException catch (e) {
      _loginFailStatusCode = e.message;
      _loginFailFeedback = true;
      return false;
    } catch (e) {
      // print(e);
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
                margin: const EdgeInsets.only(top: 50, bottom: 10),
                child: const Image(
                  image: AssetImage('assets/images/logo-init.png'),
                  height: 150,
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
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: passwordHintText,
                          focusColor: const Color(primaryColor),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF868686), width: 2, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                  ),
                  onPressed: () async {
                    bool hasLoggedIn = await _login(document, password);

                    if (_loginFailFeedback) {
                      if (_loginFailStatusCode == 401) {
                        ScaffoldMessenger.of(context).showSnackBar(invalidPasswordSnackBar);
                        _loginFailFeedback = false;
                        _loginFailStatusCode = 0;
                      } else if (_loginFailStatusCode == 404) {
                        ScaffoldMessenger.of(context).showSnackBar(userNotFoundSnackBar);
                        _loginFailFeedback = false;
                        _loginFailStatusCode = 0;
                      }
                      return;
                    }

                    if (hasLoggedIn) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Environments(),
                        ),
                      );
                    } else {
                      bool hasConnection = await checkInternetConnectivityPing();
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
