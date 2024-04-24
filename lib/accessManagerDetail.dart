import 'package:flutter/material.dart';
import 'package:laica_mobile/environments.dart';
import 'package:laica_mobile/utils/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class AccessManagerDetail extends StatefulWidget {
  final EnvironmentManager environment;

  const AccessManagerDetail({Key? key, required this.environment}) : super(key: key);

  @override
  _AccessManagerDetailState createState() => _AccessManagerDetailState(environment: environment);
}

class _AccessManagerDetailState extends State<AccessManagerDetail> {
  var accessOkSnackBar = SnackBar(content: Text('Solicitação de acesso realizada!'), duration: Duration(seconds: 4), backgroundColor: Colors.lightGreen.shade400);
  var accessFailSnackBar = SnackBar(content: Text('Houve algum problema com a solicitação de acesso...'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);
  var locationFailSnackBar = SnackBar(content: Text('É preciso estar no local do ambiente para acessar!'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);
  var geolocationFailSnackBar = SnackBar(content: Text('Ocorreu algum erro durante a geolocalização, tente novamente mais tarde'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);

  late EnvironmentManager environment;

  _AccessManagerDetailState({required this.environment});

  @override
  void initState() {
    super.initState();
  }

  String _createdAt() {
    DateTime createdAt = environment.createdAt;
    String date = "${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year.toString().padLeft(2, '0')}";
    return date;
  }

  Future<void> access() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? id = await storage.read(key: 'id');
    final uri = Uri.parse('https://laica.ifrn.edu.br/access-control/gateway/access/mobile');
    final headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
        uri,
        body: {'environmentId': environment.id, 'mobileId': id},
        headers: headers
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(accessOkSnackBar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(accessFailSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    Position? _currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;

    Future<void> _getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        ScaffoldMessenger.of(context).showSnackBar(geolocationFailSnackBar);
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      _currentLocation = await Geolocator.getCurrentPosition();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFED2F59),
            weight: 30,
            size: 35,
          ),
          onPressed: () {
            Navigator
                .of(context)
                .push(
                MaterialPageRoute(
                    builder: (bc) => const Environments()
                )
            );
          },
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getCurrentLocation();
          double distance = Geolocator.distanceBetween(_currentLocation!.latitude, _currentLocation!.longitude, environment.latitude, environment.longitude);

          if (distance > 15) {
            ScaffoldMessenger.of(context).showSnackBar(locationFailSnackBar);
          } else {
            await access();
          }
        },

        backgroundColor: const Color(0xFFED2F59),
        child: const Image(
          color: Colors.white,
          image: AssetImage('assets/images/access.png'),
          height: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Nome: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: environment.name,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Criado por: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: environment.createdBy,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Criado em: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: _createdAt(),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Descrição: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: environment.description,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Card(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Frequentadores', textAlign: TextAlign.center),
                  ),
                  Divider(),
                  ListView.builder(
                    itemCount: environment.frequenters.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(environment.frequenters[index].userName),
                      );
                    },
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Supervisores', textAlign: TextAlign.center),
                  ),
                  Divider(),
                  ListView.builder(
                    itemCount: environment.managers.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(environment.managers[index].userName),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
