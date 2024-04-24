// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:flutter/material.dart';
//
// class QRCodeWidget extends StatefulWidget {
//   String mensagem = "";
//
//   QRCodeWidget({Key? key, required this.mensagem}) : super(key: key);
//
//   @override
//   State<QRCodeWidget> createState() => _QRCodeWidgetState();
// }
//
// class _QRCodeWidgetState extends State<QRCodeWidget> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
//   QRViewController? controller;
//   String result = "";
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData.code!;
//         passToPreviousPage();
//       });
//     });
//     this.controller?.pauseCamera();
//   }
//
//   passToPreviousPage() {
//     controller?.pauseCamera();
//     widget.mensagem = result;
//     Navigator.pop(context, widget.mensagem);
//   }
//
//   @override
//   void initState() {
//     super.initState();
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
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                   borderColor: Colors.red,
//                   borderWidth: 10.0,
//                   overlayColor: const Color(0x99000000)
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }