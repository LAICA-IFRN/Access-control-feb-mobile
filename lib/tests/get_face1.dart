// import 'package:face_camera/face_camera.dart';
// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'dart:io';
//
// class GetFaceWidget extends StatefulWidget {
//   String mensagem = "";
//
//   GetFaceWidget({Key? key, required this.mensagem}) : super(key: key);
//
//   @override
//   State<GetFaceWidget> createState() => _GetFaceWidgetState();
// }
//
// class _GetFaceWidgetState extends State<GetFaceWidget> {
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   initCamera() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await FaceCamera.initialize();
//   }
//
//   sendImageEncodedBack(File? image) async {
//     Uint8List _bytes = await image!.readAsBytes();
//     widget.mensagem = base64.encode(_bytes);
//     Navigator.pop(context, widget.mensagem);
//   }
//
//   Widget _message(String msg) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//     child: Text(msg,
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontSize: 14,
//         height: 1.7,
//         fontWeight: FontWeight.w400
//       )
//     ),
//   );
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
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: SmartFaceCamera(
//               autoCapture: true,
//               defaultCameraLens: CameraLens.front,
//               onCapture: (File? image) {
//                 sendImageEncodedBack(image);
//               },
//               onFaceDetected: (Face? face) {},
//               messageBuilder: (context, face) {
//                 if (face == null) {
//                   return _message('Mantenha seu rosto na câmera');
//                 }
//                 if (!face.wellPositioned) {
//                   return _message('Centralize seu rosto no quadrado');
//                 }
//                 return const SizedBox.shrink();
//               }
//             )
//           ),
//         ],
//       ),
//     );
//   }
// }