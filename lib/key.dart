import 'package:dsd/environments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyKey extends StatelessWidget {
  static const primaryColor = 0xFFED2F59;
  static const secundaryColor = 0xb8b8b8b8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
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
                Text("Bem vindo, Hilquias. Aqui você pode acessar a chave e a lista de ambientes disponiveis"),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Row(
                    children: [
                      TextButton(
                        child: Text(
                          'Chave',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(primaryColor)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 65, vertical: 20)),
                        ),
                        onPressed: () { print("click"); },
                      ),
                      TextButton(
                        child: Text(
                          'Ambientes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(secundaryColor)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 65, vertical: 20)),
                        ),
                        onPressed: (){
                          Navigator
                              .of(context)
                              .push(
                              MaterialPageRoute(
                                  builder: (context) => Environments()
                              )
                          );
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Image(
                        image: AssetImage('images/blue2.png'),
                        height: 150,
                      ),
                    ),
                    Text(
                      'Procurando...',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
  }
}