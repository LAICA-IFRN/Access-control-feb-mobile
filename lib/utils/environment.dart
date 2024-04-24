import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnvironmentUser {
  final int envType;
  final String name;
  final String id;
  final String createdBy;
  final String description;
  final bool active;
  final DateTime createdAt;
  final DateTime startPeriod;
  final DateTime endPeriod;
  final double latitude;
  final double longitude;
  final List<EnvironmentUserAccessControl> environmentUserAccessControl;

  EnvironmentUser({
    required this.envType,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.createdBy,
    required this.description,
    required this.createdAt,
    required this.active,
    required this.startPeriod,
    required this.endPeriod,
    required this.environmentUserAccessControl,
  });

  factory EnvironmentUser.fromJson(Map<String, dynamic> json) {
    return EnvironmentUser(
      envType: json['envType'] as int,
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      id: json['id'] as String,
      description: json['description'] != null ? json['description'] as String : 'Sem descrição',
      createdBy: json['created_by'] as String,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      startPeriod: DateTime.parse(json['startPeriod'] as String),
      endPeriod: DateTime.parse(json['endPeriod'] as String),
      environmentUserAccessControl: (json['environment_user_access_control']!
      as List<dynamic>)
          .map((e) => EnvironmentUserAccessControl.fromJson(e))
          .toList(),
    );
  }
}

class EnvironmentUserAccessControl {
  final int day;
  final DateTime start;
  final DateTime end;
  final bool noAccessRestrict;

  EnvironmentUserAccessControl({
    required this.day,
    required this.start,
    required this.end,
    required this.noAccessRestrict,
  });

  factory EnvironmentUserAccessControl.fromJson(Map<String, dynamic> json) {
    return EnvironmentUserAccessControl(
      day: (json['day'] as int) + 1,
      start: DateTime.parse(json['start_time'] as String).toLocal(),
      end: DateTime.parse(json['end_time'] as String).toLocal(),
      noAccessRestrict: json['no_access_restrict'] as bool,
    );
  }
}

class EnvironmentManager {
  final int envType;
  final String name;
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String description;
  final double latitude;
  final double longitude;
  final List<User> frequenters;
  final List<User> managers;
  final List<Restriction> restrictions;

  EnvironmentManager({
    required this.envType,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.frequenters,
    required this.managers,
    required this.restrictions,
  });

  factory EnvironmentManager.fromJson(Map<String, dynamic> json) {
    return EnvironmentManager(
      envType: json['envType'] as int,
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      description: json['description'] != null ? json['description'] as String : 'Sem descrição',
      frequenters: (json['frequenters'] as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList(),
      managers: (json['managers'] as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList(),
      restrictions: (json['restrictions'] as List<dynamic>)
          .map((e) => Restriction.fromJson(e))
          .toList(),
    );
  }
}

class User {
  final String userName;

  User({
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['user_name'] as String,
    );
  }
}

class Restriction {
  final int day;
  final DateTime start;
  final DateTime end;

  Restriction({
    required this.day,
    required this.start,
    required this.end,
  });

  factory Restriction.fromJson(Map<String, dynamic> json) {
    return Restriction(
      day: json['day'] as int,
      start: DateTime.parse(json['start_time'] as String).toLocal(),
      end: DateTime.parse(json['end_time'] as String).toLocal(),
    );
  }
}

Future<List<dynamic>?> createEnvironments() async {
  const storage = FlutterSecureStorage();

  final String? token = await storage.read(key: 'token');
  final String? id = await storage.read(key: 'id');

  final uri = Uri.parse('https://laica.ifrn.edu.br/access-control/gateway/devices/mobile?id=$id');

  final headers = {
    'Authorization': 'Bearer $token',
  };

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    final environments = responseJson['environments'] as List<dynamic>;
    List<EnvironmentUser> environmentUsers = [];
    List<EnvironmentManager> environmentManagers = [];
    for (var environment in environments) {
      if (environment['envType'] == 1 || environment['envType'] == 3) {
        environmentManagers.add(EnvironmentManager.fromJson(environment as Map<String, dynamic>));
      } else if (environment['envType'] == 2) {
        environmentUsers.add(EnvironmentUser.fromJson(environment as Map<String, dynamic>));
      }
    }
    return [
      ...environmentUsers,
      ...environmentManagers
    ];
  } else {
    print(response.statusCode);
    print(response.body);
    return null;
    //throw Exception('Failed to fetch environments.');
  }
}

