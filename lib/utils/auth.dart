import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Token {
  final String jwt;
  final String mobileId;

  const Token({required this.jwt, required this.mobileId});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      jwt: json['accessToken'] as String,
      mobileId: json['mobileId'].toString(),
    );
  }
}

Future<String> registration(String token) async {
  final uri = Uri.parse('http://laica.ifrn.edu.br/access-control/gateway/devices/mobile');

  final headers = {
    'Authorization': 'Bearer $token',
  };
  final response = await http.post(uri, headers: headers);

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    String id = data['id'] as String;
    return id;
  } else {
    // TODO: msg de erro e fechar app
    throw Exception('Failed to register device.');
  }
}

Future<Token> createToken(String document, String password) async {
  const storage = FlutterSecureStorage();

  var body = {'document': document, 'password': password};
  String? mobileId = await storage.read(key: 'id');

  if (mobileId != null) {
    body['mobileId'] = mobileId;
  }

  final uri = Uri.parse('http://laica.ifrn.edu.br/access-control/gateway/tokenize/mobile');

  final response = await http.post(uri, body: body);

  if (response.statusCode == 201) {
    var json = jsonDecode(response.body);
    if (json['mobileId'] == false) {
      String? id = await registration(json['accessToken']);
      json['mobileId'] = id;
    }
    return Token.fromJson(json as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create token.');
  }
}

Future<bool?> verifyToken(String? token) async {
  final url = Uri.parse("http://laica.ifrn.edu.br/access-control/gateway/tokenize/verify/mobile?token=$token");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['isValid']) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
