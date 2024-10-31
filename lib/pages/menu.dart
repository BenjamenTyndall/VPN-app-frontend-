import 'package:flutter/material.dart';
import 'package:firstapp/pages/login.dart';
import 'package:firstapp/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late SharedPreferences prefs;
  bool isToggleEnabled = true;
  TextEditingController textField1Controller = TextEditingController(text: '443');
  TextEditingController textField2Controller = TextEditingController(text: 'udp');

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggleEnabled = prefs.getBool('isToggleEnabled') ?? true;
      textField1Controller.text = prefs.getInt('port').toString() ?? '443';
      textField2Controller.text = prefs.getString('protocol') ?? 'udp';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginApp(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Settings',
      theme: isToggleEnabled ? lightTheme : darkTheme,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Settings'),
          backgroundColor: Color.fromRGBO(40, 45, 209, 100),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Light/Dark theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: isToggleEnabled,
                onChanged: (value) async {
                  setState(() {
                    isToggleEnabled = value;
                  });
                  await prefs.setBool('isToggleEnabled', value);
                },
              ),
              SizedBox(height: 20),
              Text(
                'Port',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: textField1Controller,
                keyboardType: TextInputType.number, // Ensure the keyboard is numeric
                decoration: InputDecoration(
                  hintText: '443',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Protocol',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: textField2Controller,
                decoration: InputDecoration(
                  hintText: 'udp, http, tcp',
                  border: OutlineInputBorder(),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginApp()),
                      );
                      final response = await http.post(Uri.parse('http://localhost/virtualPN/logout.php'));
                      if (response.statusCode == 200) {
                        print("Logout successful");
                      } else {
                        print("Logout failed");
                      }
                    },
                    child: Text('Log Out'),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final portValue = int.tryParse(textField1Controller.text) ?? 443;
            await prefs.setInt('port', portValue);
            await prefs.setString('protocol', textField2Controller.text);
            print("Settings saved");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromRGBO(40, 45, 209, 100),
  // Customize your light theme here
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  // Customize your dark theme here
  // Other theme properties...
);
