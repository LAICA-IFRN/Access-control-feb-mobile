import 'package:dsd/environments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Init extends StatefulWidget{
  const Init({Key? key}) : super(key: key);

  @override
  Login createState() => Login();
}

class Login extends State {
  String document = "";
  String password = "";

  final storage = const FlutterSecureStorage();

  static const homeText = 'Controle de acesso';
  static const userHintText = 'Matrícula ou CPF';
  static const passwordHintText = 'Senha';
  static const primaryColor = 0xFFED2F59;

  Future<bool> _login(String document, String password) async {
    try {
      var url = Uri.parse('http://laica.ifrn.edu.br/gateway/tokenize/mobile');

      var response = await http.post(
        url,
        body: {
          'document': document,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        await storage.write(key: 'jwt', value: response.body);
        return true;
      } else {
        print('Erro ao fazer login. Status da requisição: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      // TODO: verificar o tipo do erro e retornar uma msg que indique o motivo para o usuário
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 65),
                child: const Image(
                  image: AssetImage('images/logo.png'),
                  height: 200,
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
                margin: const EdgeInsets.only(top: 45, left: 20, right: 20),
                child: TextButton(
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 65, vertical: 20)),
                  ),
                  onPressed: () async {
                    bool hasLoggedIn = await _login(document, password);

                    if (hasLoggedIn) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Environments(),
                        ),
                      );
                    } else {
                      // TODO: exibir mensagem de erro
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
  }
}
