import 'variables.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:final_flutter_app/theme-data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




Future<User> fetchUser() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode==200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load...');
  }
}

class Geo {
  final String lat;
  final String lng;

  const Geo({
    required this.lat,
    required this.lng,
  });
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  const Address ({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company ({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const User ({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address(
        street: json['address']['street'],
        suite: json['address']['suite'],
        city: json['address']['city'],
        zipcode: json['address']['zipcode'],
        geo: Geo(
          lat: json['address']['geo']['lat'],
          lng: json['address']['geo']['lng'],
        ),
      ),
      phone: json['phone'],
      website: json['website'],
      company: Company(
        name: json['company']['name'],
        catchPhrase: json['company']['catchPhrase'],
        bs: json['company']['bs'],
      ),
    );
  }
}



class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  String? _userStoredName;
  String? _userStoredPass;

  bool _checkAuthorization()
  {
    if (
    (_userStoredName == Messages.userName)&&(_userStoredPass == Messages.userPass)
    )
    {
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
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    const borderStyle=OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
            color: const Color(0x32647ae2), width:3));
    const borderStyle2=OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(
            color: const Color(0x1d000000), width:2));


    if (_checkAuthorization()) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.amber,
          title: const Text('Рейтинг блиноедов'),
        ),
        //drawer: navDrawer(context),
        drawer: Drawer(
          child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  //https://ampravda.ru/files/articles-2/46669/ugdkdxfl8w0j.jpg
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Container(
                    height:100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("PANCAKE APP", textScaleFactor: 2,),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          height:100,
                          child: Image.network("https://ampravda.ru/files/articles-2/46669/ugdkdxfl8w0j.jpg"),

                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.water_damage_rounded),
                  title: const Text("О блинах"),
                  onTap: (){
                    Navigator.pushNamed(context, '/');
                  },

                ),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text("Список блиноедов"),
                  onTap: (){
                    Navigator.pushNamed(context, '/users');

                  },

                ),
                ListTile(
                  leading: const Icon(Icons.two_k),
                  title: const Text("Секреты теста"),
                  onTap: (){
                    Navigator.pushNamed(context, '/page');
                  },

                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Text("Профиль",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Настройки"),
                  onTap: (){},



                ),
        SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              onPressed: (){
                _userStoredName ='';
                _userStoredPass ='';
                _saveUserData();
                setState(() {});
              },
              child: const Text(Messages.buttonExit)),)
              ]
          ),
        ),


        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text("      Древнерусское слово блин происходит от млин, связанного с глаголами мелю, молоть. То есть обозначает изделие из смолотого зерна, муки. В русской кухне блины появились не позднее IX века. Предшественниками блинов и оладьев из дрожжевого теста (кислого, заквашенного) были блинчики, оладьи и лепёшки из пресного теста.",
                    textScaleFactor: 1.1, textAlign: TextAlign.justify, style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                ),
                SizedBox(height:40),
                Row(
                  children: const [
                    Expanded(child: SizedBox(height: 20)),
                  ],
                ),
                ElevatedButton(


                    style: ElevatedButton.styleFrom(
                        //padding: EdgeInsets.all(70),
                        shape: CircleBorder(),
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 70),
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    onPressed: (){
                      Navigator.pushNamed(context, '/users');

                    },
                    child: const Text("ЗАГРУЗИТЬ СПИСОК БЛИНОЕДОВ", textAlign: TextAlign.center,)
                ),
                const SizedBox(height: 20),




              ],
            ),
          ),
        ),

      );




    }

    else {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              )
          ),
          width: double.infinity,
          height: double.infinity,
          //padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height:120,),
                  Image.asset("assets/images/logo.png"),
                  SizedBox(height:30,),


                  Text("Введите номер телефона", style: TextStyle(fontSize: 14,color: Color.fromRGBO(0, 0, 0, 0.4))),
                  SizedBox(height:30,),

                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: userController,
                          keyboardType: TextInputType.phone,

                          decoration: InputDecoration(
                            enabledBorder: borderStyle,
                            focusedBorder: borderStyle2,
                            filled: true,
                            fillColor: Color(0x5Edbebf6),
                            labelText: "+7 xxx xxx xx xx",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Messages.error1;
                            } else if (value.length <3){
                              return Messages.error2;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: borderStyle,
                            focusedBorder: borderStyle2,
                            filled: true,
                            fillColor: Color(0x5Edbebf6),
                            labelText: "пароль",
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Messages.error1;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            _userStoredName = userController.text;
                            _userStoredPass = passController.text;
                            if (_checkAuthorization()) {
                              _saveUserData();
                            } else {
                              _userStoredName = '';
                              _userStoredPass = '';
                              _saveUserData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Ошибка авторизации"), backgroundColor:Colors.red),
                              );
                            }
                          }
                          setState(() {});
                        },
                        child: const Text("ВХОД")
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(height:100,),
                  const Text("FINAL Case, author: Gorlanov AA", style: TextStyle(
                    fontWeight: FontWeight.bold)),
                  SizedBox(height:10,),
                  const Text("DEMO LOGIN:${Messages.userName}"),
                  const Text("DEMO PASSWORD${Messages.userPass}"),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}