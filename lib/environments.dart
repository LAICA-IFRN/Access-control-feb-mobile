import 'dart:async';

import 'package:flutter/services.dart';
import 'package:laica_mobile/accessFrequenterDetail.dart';
import 'package:laica_mobile/accessManagerDetail.dart';
import 'package:laica_mobile/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Environments extends StatefulWidget {
  const Environments({Key? key}) : super(key: key);

  @override
  HandleEnvironments createState() => HandleEnvironments();
}

class HandleEnvironments extends State {
  List<dynamic> stateEnvironments = [];
  final storage = const FlutterSecureStorage();
  static const primaryColor = 0xFFED2F59;

  @override
  initState() {
    super.initState();
    _getEnvironments();
  }


  Future<void> _getEnvironments() async {
    List<dynamic>? temp = await createEnvironments();
    if (temp == null) {
      return;
    }
    setState(() {
      stateEnvironments = temp;
    });
  }

  Future<void> _removeToken() async {
    await storage.write(key: 'token', value: '');
    Timer(Duration(seconds: 2), () => SystemNavigator.pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          child: Text(
            "Sair",
            style: TextStyle(
              color: Colors.red.shade400,
              fontSize: 18
            ),
          ),
          onPressed: () async {
            await _removeToken();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 55),
          child: const Image(
            image: AssetImage('assets/images/logo-nav.png'),
            height: 70,
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 85,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: stateEnvironments.length,
                itemBuilder: (BuildContext context, int index) {
                  var environment = stateEnvironments[index];
                  return environment.envType == 2 ?
                  Container(
                    //color: Color(0xc8c8c8c8),
                    padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xffececec)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nome'),
                            const SizedBox(height: 5),
                            Text(
                              environment.name,
                              style: const TextStyle(
                                color: Color(primaryColor),
                                //fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vínculo'),
                            SizedBox(height: 5),
                            Text(
                              "Frequentador",
                              style: TextStyle(
                                color: Color(primaryColor),
                                //fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            ),
                          ),
                          onPressed: () {
                            Navigator
                                .of(context)
                                .push(
                                MaterialPageRoute(
                                    builder: (bc) => AccessFrequenterDetails(environment: environment)
                                )
                            );
                          },
                          child: const Text(
                            'Detalhes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ) :
                  Container(
                    padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xffececec)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nome'),
                            const SizedBox(height: 5),
                            Text(
                              environment.name,
                              style: const TextStyle(
                                color: Color(primaryColor),
                                //fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vínculo'),
                            const SizedBox(height: 5),
                            Text(
                              environment.envType == 1 ? "Admin" : "Supervisor",
                              style: const TextStyle(
                                color: Color(primaryColor),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            ),
                          ),
                          onPressed: () {
                            Navigator
                                .of(context)
                                .push(
                                MaterialPageRoute(
                                    builder: (bc) => AccessManagerDetail(environment: environment)
                                )
                            );
                          },
                          child: const Text(
                            'Detalhes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:laica_mobile/accessFrequenterDetail.dart';
// import 'package:laica_mobile/access.dart';
// import 'package:laica_mobile/utils/environment.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class Environments extends StatefulWidget {
//   const Environments({Key? key}) : super(key: key);
//
//   @override
//   HandleEnvironments createState() => HandleEnvironments();
// }
//
// class HandleEnvironments extends State {
//   List<Environment> stateEnvironments = [];
//
//   final storage = const FlutterSecureStorage();
//
//   static const primaryColor = 0xFFED2F59;
//
//   @override
//   void initState() {
//     super.initState();
//     _getEnvironments();
//   }
//
//   Future<void> _getEnvironments() async {
//     List<Environment> temp = await createEnvironments();
//     setState(() {
//       stateEnvironments = temp;
//     });
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
//         backgroundColor: Colors.white, //<-- SEE HERE
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             // Container(
//             //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             //   child: const Text(
//             //     "Bem-vindo, Hilquias. Aqui você pode tem acesso a chave e a lista de ambientes.",
//             //     style: TextStyle(
//             //         color: Color(0xa8a8a8a8),
//             //         fontSize: 18.0,
//             //         fontFamily: 'Roboto',
//             //         fontWeight: FontWeight.normal
//             //     ),
//             //   ),
//             // ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
//                       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
//                     ),
//                     onPressed: () { print("click"); },
//                     child: const Text(
//                       'Ambientes',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.normal
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(const Color(0xb8b8b8b8)),
//                       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
//                     ),
//                     onPressed: (){
//                       Navigator
//                           .of(context)
//                           .push(
//                           MaterialPageRoute(
//                               builder: (bc) => const Access()
//                           )
//                       );
//                     },
//                     child: const Text(
//                       'Acesso',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.normal
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: stateEnvironments.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   var environmentUser = stateEnvironments[index];
//                   return Container(
//                     //color: Color(0xc8c8c8c8),
//                     padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
//                     margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                         color: Color(0xffececec)
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Nome'),
//                             const SizedBox(height: 5),
//                             Text(
//                               environmentUser.name,
//                               style: const TextStyle(
//                                 color: Color(primaryColor),
//                                 //fontSize: 16.0,
//                                 fontFamily: 'Roboto',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Status'),
//                             const SizedBox(height: 5),
//                             Text(
//                               environmentUser.active ? "Ativo" : "Inativo",
//                               style: const TextStyle(
//                                 color: Color(primaryColor),
//                                 //fontSize: 16.0,
//                                 fontFamily: 'Roboto',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           ],
//                         ),
//                         TextButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
//                             padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                               const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator
//                                 .of(context)
//                                 .push(
//                                 MaterialPageRoute(
//                                     builder: (bc) => AccessDetails(environment: environmentUser)
//                                 )
//                             );
//                           },
//                           child: const Text(
//                             'Detalhes',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.0,
//                               fontFamily: 'Roboto',
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }