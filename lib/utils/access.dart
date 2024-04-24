// import 'package:laica_mobile/environments.dart';
// import 'package:flutter/material.dart';
// import 'package:laica_mobile/tests/get_face1.dart';
// import 'package:laica_mobile/tests/scan.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:convert';
//
// class Access extends StatefulWidget {
//   const Access({super.key});
//
//   @override
//   State<Access> createState() => _Access();
// }
//
// class EnvObject {
//   late String token;
//   late String name;
//   late double latitude;
//   late double longitude;
// }
//
// class _Access extends State<Access> {
//   static const primaryColor = 0xFFED2F59;
//   static const secundaryColor = 0xb8b8b8b8;
//   static const boxName = 'loggedEnvs';
//
//   String qrcode = "";
//   String encodedImage = "";
//   Box? box;
//   Iterable<dynamic> boxValues = [];
//
//   @override
//   void initState() {
//     initHive();
//     super.initState();
//   }
//
//   initHive() async {
//     var dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     bool isBoxCreated = await Hive.boxExists(boxName);
//
//     if (isBoxCreated) {
//       Box temp = await Hive.openBox(boxName);
//       setState(() {
//         box = temp;
//       });
//     }
//     else {
//       Box temp = await Hive.openBox(boxName);
//       setState(() {
//         box = temp;
//       });
//     }
//   }
//
//   handleQrcode(String qrcode) async {
//     final scaffold = ScaffoldMessenger.of(context);
//
//     String extractQrcode = qrcode.substring(0, qrcode.length - 1);
//     String espId = qrcode.substring(qrcode.length - 1);
//
//     if (alreadyVerified(espId)) {
//       scaffold.showSnackBar(
//         SnackBar(
//           content: const Text('Este ambiente já foi identificado hoje'),
//           action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white),
//           backgroundColor: Colors.red.shade400,
//           duration: const Duration(seconds: 5),
//         ),
//       );
//     } else {
//       String responseJson = await tokenizeAccess(extractQrcode, espId);
//
//       if (responseJson != "") {
//         final json = jsonDecode(responseJson) as Map<String, dynamic>;
//         addEnvFromJson(json, espId);
//         scaffold.showSnackBar(
//           SnackBar(
//             content: const Text('Ambiente identificado com sucesso'),
//             action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white),
//             backgroundColor: Colors.lightGreen.shade400,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<String> tokenizeAccess(String extractQrcode, String espId) async {
//     const storage = FlutterSecureStorage();
//     final String? token = await storage.read(key: 'token');
//     final url = Uri.parse('https://laica.ifrn.edu.br/access-control/gateway/tokenize/access');
//
//     final body = {
//       "qrcode": extractQrcode,
//       "microcontrollerId": espId
//     };
//     final headers = {
//       'Authorization': 'Bearer $token',
//     };
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 201) {
//       print(response.body);
//       return response.body;
//     } else {
//       print(response.statusCode);
//       print(response.body);
//       final scaffold = ScaffoldMessenger.of(context);
//       scaffold.showSnackBar(
//         SnackBar(
//           content: const Text('QRCode inválido, tente novamente.'),
//           action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white),
//           backgroundColor: Colors.red.shade400,
//           duration: const Duration(seconds: 5),
//         ),
//       );
//       return "";
//     }
//   }
//
//   bool alreadyVerified(String espId) {
//     dynamic temp = box?.get(espId);
//     if (temp != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   void addEnvFromJson(Map<String, dynamic> json, String espId) async {
//     await box?.put(espId, {
//       "token": json['token'] as String,
//       "latitude": json['latitude'] as double,
//       "longitude": json['longitude'] as double,
//       "name": json['name'] as String,
//     });
//     setState(() {});
//   }
//
//   handleAccess(int index) async {
//     var environment = box?.values.elementAt(index);
//     print(environment["latitude"]);
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GetFaceWidget(mensagem: encodedImage),
//       ),
//     );
//
//     print(result.toString().length);
//     // await checkLocation(environment["latitude"], environment["longitude"]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 55),
//           child: const Image(
//             image: AssetImage('assets/images/logo-nav.png'),
//             height: 70,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Center(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(const Color(secundaryColor)),
//                         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
//                       ),
//                       onPressed: () {
//                         Navigator
//                             .of(context)
//                             .push(
//                             MaterialPageRoute(
//                                 builder: (bc) => const Environments()
//                             )
//                         );
//                       },
//                       child: const Text(
//                         'Ambientes',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.0,
//                             fontFamily: 'Roboto',
//                             fontWeight: FontWeight.normal
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
//                         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
//                       ),
//                       onPressed: (){
//                         print('click');
//                       },
//                       child: const Text(
//                         'Acesso',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   //Text("Identifique um ambiente para acessa-lo durante o dia."),
//                   TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
//                         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
//                       ),
//                       onPressed: () async {
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => QRCodeWidget(mensagem: qrcode),
//                           ),
//                         );
//                         handleQrcode(result);
//                       },
//                       child: const Text(
//                         'Identificar',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.normal,
//                         ),
//                       )
//                   )
//                 ],
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: box?.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var loggedEnv = box?.values.elementAt(index);
//                     if (loggedEnv != null) {
//                       return Container(
//                         //color: Color(0xc8c8c8c8),
//                         padding: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
//                         margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             color: Color(0xffececec)
//                         ),
//                         child: TextButton(
//                           child: Text(loggedEnv["name"]),
//                           onPressed: () async {
//                             await handleAccess(index);
//                           },
//                         ),
//                       );
//                     } else {
//                       SizedBox(height: 5);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//     );
//   }
// }