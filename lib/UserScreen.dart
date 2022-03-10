import 'dart:async';
import 'dart:convert';
import 'package:final_flutter_app/theme-data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'variables.dart';
import 'user-class.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<UserList> futureUserList;
  int _selectedIndex = -1;

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
    futureUserList = fetchUserList();
  }



  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.amber,
          title: const Text('Страница рейтинга'),
        ),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder<UserList>(
              future: futureUserList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.items.length,
                      itemBuilder:(BuildContext context, int index) {
                        return Container(
                          height: 50,

                          child: ListTile(
                            title: Row(

                              children: [
Expanded(flex:1, child:
                                Text(snapshot.data!.items[index].id.toString(), ),
),Expanded(flex:2, child:
                                Text(snapshot.data!.items[index].name, style: Theme.of(context).textTheme.bodyText1,),
                                ),
                        Expanded(flex:4, child:
                        Text(snapshot.data!.items[index].email, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.right,),
                        ),     ],
                            ),

                            selected: index == _selectedIndex,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              Navigator.pushNamed(
                                  context,
                                  '/tasks',
                                arguments: snapshot.data!.items[index].id
                              );
                            },
                          ),
                        );
                      },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                 return const CircularProgressIndicator();
              }
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

