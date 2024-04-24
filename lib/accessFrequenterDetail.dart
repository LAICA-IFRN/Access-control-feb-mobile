import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laica_mobile/environments.dart';
import 'package:laica_mobile/utils/environment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class AccessEvent {
  final String label;
  AccessEvent(this.label);
}

class AccessFrequenterDetails extends StatefulWidget {
  final EnvironmentUser environment;

  const AccessFrequenterDetails({Key? key, required this.environment}) : super(key: key);

  @override
  _AccessFrequenterDetailsState createState() => _AccessFrequenterDetailsState(environment: environment);
}

class _AccessFrequenterDetailsState extends State<AccessFrequenterDetails> {
  var accessOkSnackBar = SnackBar(content: Text('Solicitação de acesso realizada!'), duration: Duration(seconds: 4), backgroundColor: Colors.lightGreen.shade400);
  var accessFailSnackBar = SnackBar(content: Text('Houve algum problema com a solicitação de acesso...'), duration: Duration(seconds: 4), backgroundColor: Colors.red.shade400);

  final EnvironmentUser environment;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<AccessEvent>> accesses = {};
  late final ValueNotifier<List<AccessEvent>> _selectedEvents;

  _AccessFrequenterDetailsState({required this.environment});

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

  List<AccessEvent> _getEventsForDay(DateTime day) {
    final events = <AccessEvent>[];

    for (final environmentUserAccessControl in environment.environmentUserAccessControl) {
      if (environmentUserAccessControl.day == day.weekday) {
        int startHours = environmentUserAccessControl.start.hour;
        int startMinutes = environmentUserAccessControl.start.minute;
        int endHours = environmentUserAccessControl.end.hour;
        int endMinutes = environmentUserAccessControl.end.minute;
        final label = '${startHours.toString().padLeft(2, '0')}:${startMinutes
            .toString().padLeft(2, '0')} - ${endHours.toString().padLeft(
            2, '0')}:${endMinutes.toString().padLeft(2, '0')}';
        final accessEvent = AccessEvent(label);

        events.add(accessEvent);
      }
    }

    if (events.isEmpty) {
      return [];
    }

    return events;
  }

  String _getPeriodAccess() {
    DateTime startPeriod = environment.startPeriod;
    DateTime endPeriod = environment.endPeriod;
    String start = "${startPeriod.day.toString().padLeft(2, '0')}/${startPeriod.month.toString().padLeft(2, '0')}/${startPeriod.year.toString().padLeft(2, '0')}";
    String end = "${endPeriod.day.toString().padLeft(2, '0')}/${endPeriod.month.toString().padLeft(2, '0')}/${endPeriod.year.toString().padLeft(2, '0')}";
    return "Acesso válido entre $start e $end";
  }

  String _createdAt() {
    DateTime createdAt = environment.createdAt;
    String date = "${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year.toString().padLeft(2, '0')}";
    return date;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    initializeDateFormatting('pt_BR', null);
  }

  @override
  Widget build(BuildContext context) {
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
            await access();
          },
          backgroundColor: const Color(0xFFED2F59),
          child: const Image(
            color: Colors.white,
            image: AssetImage('assets/images/access.png'),
            height: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          mainAxisSize: MainAxisSize.max,
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
            TableCalendar(
              locale: 'pt_BR',
              firstDay: environment.startPeriod,
              lastDay: environment.endPeriod,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                formatButtonTextStyle: const TextStyle(
                ),
                formatButtonDecoration: BoxDecoration(
                  color: const Color(0xFFED2F59),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                formatButtonShowsNext: false,
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Color(0xB8F84068),
                    shape: BoxShape.circle
                ),
                selectedDecoration: BoxDecoration(
                    color: Color(0xFFED2F59),
                    shape: BoxShape.circle
                ),
                markerDecoration: BoxDecoration(
                  color: Color(0xFFED2F59),
                  shape: BoxShape.circle,
                ),

              )
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ValueListenableBuilder<List<AccessEvent>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            if (index < value.length) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  //border: Border.all(),
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFED2F59),
                                  //shape: BoxShape.circle
                                ),
                                child: ListTile(
                                  title: Center(
                                    child: Text(value[index].label),
                                  ),
                                  titleTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                      );
                    }
                )
            )
          ],
        )
    );
  }
}
