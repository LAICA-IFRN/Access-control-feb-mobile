import 'package:dsd/key.dart';
import 'package:flutter/material.dart';

class Ambiente {
  final String name;
  final bool active;

  Ambiente({required this.name, required this.active});
}

class Environments extends StatelessWidget {
  static const primaryColor = 0xFFED2F59;

  @override
  Widget build(BuildContext context) {
    List<Ambiente> myState = [
      Ambiente(name: 'Ambiente 1', active: true),
      Ambiente(name: 'Ambiente 2', active: false),
      Ambiente(name: 'Ambiente 3', active: true),
      Ambiente(name: 'Ambiente 4', active: false),
    ];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('images/logo.png'),
                    height: 75,
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white, //<-- SEE HERE
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Bem-vindo, Hilquias. Aqui você pode tem acesso a chave e a lista de ambientes.",
                  style: TextStyle(
                      color: Color(0xa8a8a8a8),
                      fontSize: 18.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    TextButton(
                      child: const Text(
                        'Chave',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xb8b8b8b8)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 53, vertical: 20)),
                      ),
                      onPressed: (){
                        Navigator
                            .of(context)
                            .push(
                            MaterialPageRoute(
                                builder: (bc) => MyKey()
                            )
                        );
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Ambientes',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 45, vertical: 20)),
                      ),
                      onPressed: () { print("click"); },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myState.length,
                  itemBuilder: (BuildContext context, int index) {
                    var objeto = myState[index];
                    return Container(
                      //color: Color(0xc8c8c8c8),
                      padding: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                                '${objeto.name}',
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
                              const Text('Status'),
                              const SizedBox(height: 5),
                              Text(
                                '${objeto.active ? "Ativo" : "Inativo"}',
                                style: const TextStyle(
                                  color: Color(primaryColor),
                                  //fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          TextButton(
                            child: const Text(
                              'Horários',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(primaryColor)),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                              ),
                            ),
                            onPressed: () {
                              print("click");
                            },
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