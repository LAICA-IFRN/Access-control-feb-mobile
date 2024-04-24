// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: GeolocationTest(),
//   ));
// }
//
// class GeolocationTest extends StatefulWidget {
//   const GeolocationTest({super.key});
//
//   @override
//   State<GeolocationTest> createState() => _GeolocationTestState();
// }
//
// class _GeolocationTestState extends State<GeolocationTest> {
//
//   @override
//   Widget build(BuildContext context) {
//     Position? _currentLocation;
//     late bool servicePermission = false;
//     late LocationPermission permission;
//
//     String _currentAddress = "";
//
//     Future<Position> _getCurrentLocation() async {
//       servicePermission = await Geolocator.isLocationServiceEnabled();
//       if (!servicePermission) {
//         print("service disable");
//       }
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       return await Geolocator.getCurrentPosition();
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Get user location"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Location coordinates",
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text("Coordinates"),
//             const SizedBox(height: 30.0),
//             const Text(
//               "Location address",
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text("Address"),
//             const SizedBox(height: 50.0),
//             ElevatedButton(onPressed: () async {
//               _currentLocation = await _getCurrentLocation();
//               print("$_currentLocation");
//               double a = Geolocator.distanceBetween(_currentLocation!.latitude, _currentLocation!.longitude, -5.8115434, -35.2023686);
//               double b = Geolocator.distanceBetween(_currentLocation!.latitude, _currentLocation!.longitude, -5.8115454, -35.2024514);
//               double c = Geolocator.distanceBetween(_currentLocation!.latitude, _currentLocation!.longitude, -5.811643, -35.202166);
//               // -5.8115434, -35.2023686
//               // -5.8115454, -35.2024514
//               // -5.811643, -35.202166
//               print(a);
//               _currentAddress = _currentLocation.toString();
//               var snackBar = SnackBar(content: Text('primeira: ${a.round()} | segunda: ${b.round()} | terceira: ${c.round()}'));
//               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//             }, child: Text("get Location"))
//           ],
//         ),
//       ),
//     );
//   }
// }