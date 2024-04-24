// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:face_camera/face_camera.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await FaceCamera.initialize();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   File? _capturedImage;
//   String _base64String = "";
//
//   void convertImage() async {
//     print(_capturedImage!.path);
//     print(_capturedImage!.length());
//
//     Uint8List _bytes = await _capturedImage!.readAsBytes();
//
//     // final jpgImage = Image.memory(_bytes);
//
//     // String string = base64.encode(jpgImage.toByteData());
//     String string = base64.encode(_bytes);
//     print(string.length);
//
//     final uri = Uri.parse('https://laica.ifrn.edu.br/access-ng/log/test');
//     final response = await http.post(
//       uri,
//       body: {'base64': string},
//     );
//     print(response.statusCode);
//     print(response.body);
//     print(response.headers);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('FaceCamera example app'),
//           ),
//           body: Builder(builder: (context) {
//             if (_capturedImage != null) {
//               return Center(
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     Image.file(
//                       _capturedImage!,
//                       width: double.maxFinite,
//                       fit: BoxFit.fitWidth,
//                     ),
//                     ElevatedButton(
//                         onPressed: () => setState(() => _capturedImage = null),
//                         child: const Text(
//                           'Capture Again',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w700),
//                         ))
//                   ],
//                 ),
//               );
//             }
//             return SmartFaceCamera(
//                 autoCapture: true,
//                 defaultCameraLens: CameraLens.front,
//                 onCapture: (File? image) {
//                   setState(() => _capturedImage = image);
//                   convertImage();
//                 },
//                 onFaceDetected: (Face? face) {
//                   //Do something
//                 },
//                 messageBuilder: (context, face) {
//                   if (face == null) {
//                     return _message('Mantenha seu rosto na câmera');
//                   }
//                   if (!face.wellPositioned) {
//                     return _message('Centralize seu rosto no quadrado');
//                   }
//                   return const SizedBox.shrink();
//                 });
//           })),
//     );
//   }
//
//   Widget _message(String msg) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//     child: Text(msg,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//             fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
//   );
// }