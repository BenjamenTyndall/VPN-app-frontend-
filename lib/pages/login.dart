import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/pages/home.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<void> loginUser(String user, String password, BuildContext context) async {
  final url = Uri.parse('http://localhost/virtualPN/login.php');
  final response = await performLoginRequest(url, user, password);

  handleLoginResponse(response, context);
}

Future<http.Response> performLoginRequest(Uri url, String user, String password) async {
  return await http.post(
    url,
    body: {
      'user': user,
      'password': password,
    },
  );
}

void handleLoginResponse(http.Response response, BuildContext context) {
  print('Response Content: ${response.body}'); // Print the raw response content for debugging
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final dynamic message = responseData['message'];
    print('Response Message: $message');
    print("connected http");
    if (message == 'passed') {
      // Handle successful login here
      print("yes");

      // Navigate to the HomeScreen after successful login
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Show a message to the user indicating a failed login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
        ),
      );
    }
  } else {
    // Handle HTTP request errors
    print('HTTP Error: ${response.statusCode}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while logging in.'),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginApp> {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Define a variable to store SharedPreferences instance
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences in initState
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Load the saved username and password
      _userController.text = _prefs.getString('username') ?? '';
      _passwordController.text = _prefs.getString('password') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text('Login - Virtual Pirate Network'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _userController,
                onChanged: (value) {
                  // Save the username when it changes
                  _prefs.setString('username', value);
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                onChanged: (value) {
                  // Save the password when it changes
                  _prefs.setString('password', value);
                },
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  String user = _userController.text;
                  String password = _passwordController.text;
                  // Pass the BuildContext to loginUser for navigation
                  loginUser(user, password, context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
