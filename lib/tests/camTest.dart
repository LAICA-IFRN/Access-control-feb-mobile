// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late CameraController _controller;
//
//   Future<void> _initializzeCamera() async {
//     List<CameraDescription> cameras = await availableCameras();
//
//     // Verifica se o aparelho permite abrir as duas câmeras
//     if (cameras.length >= 2) {
//       // Inicializa a câmera frontal
//       _controller = CameraController(
//         cameras[0],
//         ResolutionPreset.high,
//       );
//
//       await _controller.initialize();
//
//       // Inicia a captura de vídeo
//       _controller.buildPreview();
//     } else {
//       // Exibe uma mensagem de erro
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('O aparelho não permite abrir as duas câmeras ao mesmo tempo'),
//         ),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Lista as câmeras disponíveis
//     _initializzeCamera();
//   }
//
//   @override
//   void dispose() {
//     // Libera os recursos da câmera
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Câmera'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               // ...
//               SizedBox(
//                 height: 200,
//                 width: 200,
//                 child: CameraPreview(_controller),
//               ),
//               // ...
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
