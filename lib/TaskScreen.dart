import 'dart:async';
import 'dart:convert';
import 'package:final_flutter_app/theme-data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'variables.dart';
import 'user-class.dart';
import 'package:http/http.dart' as http;

class TaskMainScreen extends StatelessWidget {
  const TaskMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userID = ModalRoute.of(context)!.settings.arguments as int;

    return TaskScreen(userID: userID);
  }
}


class TaskScreen extends StatefulWidget {
  final int userID;
  const TaskScreen({Key? key, required this.userID}) : super(key: key);


  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late Future<User> _futureUser;
  late Future<TaskList> _futureTaskList;

  //USER AUTHENTICATION
  String? _userStoredName;
  String? _userStoredPass;

  bool _checkAuthorization() {
    if ((_userStoredName == Messages.userName)&&(_userStoredPass == Messages.userPass)) {
      return true;
    }
    return false;
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userStoredName = (prefs.getString('userStoredName') ?? '');
      _userStoredPass = (prefs.getString('userStoredPass') ?? '');
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userStoredName', (_userStoredName ?? ''));
    prefs.setString('userStoredPass', (_userStoredPass ?? ''));
  }
  //END OF USER AUTHENTICATION

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _futureUser = fetchSingleUser(widget.userID);
    _futureTaskList = fetchTaskList(widget.userID);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.amber,
          title: const Text('Личная карточка блиноеда'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                FutureBuilder<User>(
                    future: _futureUser,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.pancakeEater(context);
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    }
                ),
                const SizedBox(height: 5),

                FutureBuilder<TaskList>(
                    future: _futureTaskList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                          child: ListView.separated(
                            //shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data!.items.length,
                            itemBuilder:(BuildContext context, int index) {
                              return Container(
                                height: 50,

                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: snapshot.data!.items[index].completed,
                                            onChanged: (bool? value) {},
                                          ),

                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(snapshot.data!.items[index].title, style: Theme.of(context).textTheme.bodyText1,)


                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    }
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  Messages.logFail,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}