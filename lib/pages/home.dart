import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/pages/menu.dart';

import 'dart:async';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentState = "off";
  String port = '443'; // Default port
  String protocol = 'tcp'; // Default protocol

  @override
  void initState() {
    super.initState();
    // Load the dark mode preference and set the theme
    isDarkModeEnabled().then((value) {
      if (value) {
        // Dark mode is enabled, apply the light theme
        applyTheme(context);
      } else {
        // Dark mode is disabled, apply the dark theme
        applyTheme(context);
      }
    });

    // Initialize currentState based on saved state in SharedPreferences
    getState().then((value) {
      setState(() {
        currentState = value ?? "off";
      });
    });

    // Load 'port' and 'protocol' from SharedPreferences
    loadPortAndProtocol();
  }

  void toggleState() async {
    if (currentState == "on") {
      await saveState("off");
      setState(() {
        currentState = "off";
      });
    } else {
      await saveState("on");
      setState(() {
        currentState = "on";
      });
    }

    // Load the dark mode preference and set the theme
    isDarkModeEnabled().then((value) {
      if (value) {
        // Dark mode is enabled, apply the light theme
        applyTheme(context);
      } else {
        // Dark mode is disabled, apply the dark theme
        applyTheme(context);
      }
    });
  }

  Future<void> loadPortAndProtocol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      port = prefs.getInt('port').toString() ?? '443';
      protocol = prefs.getString('protocol') ?? 'Internet Protocol';
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageAsset = currentState == "on" ? "assets/icons/wifi-on.png" : "assets/icons/wifi-off.png";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Virtual Pirate Network'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.6,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                // Toggle VPN on/off
                toggleState();

                // Check the current state of the VPN (on or off)
                bool vpnIsOn = currentState == "on";

                // If the VPN is turned on, configure it with the saved SharedPreferences values
                if (vpnIsOn) {
                  try {
                    // Retrieve the saved values from SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String username = prefs.getString('username') ?? ''; // Replace with your default value
                    String password = prefs.getString('password') ?? ''; // Replace with your default value
                    int port = prefs.getInt('port') ?? 443; // Replace with your default value
                    String protocol = prefs.getString('protocol') ?? 'udp'; // Replace with your default value
                    print(username + " " + password + " " + protocol + port.toString()) ;
                    // Call the method from your Flutter plugin to configure the VPN
                   // await OpenVPNConnector.configureOpenVPN(
                   //   username: username,
                   //   password: password,
                   //   port: port,
                   //   protocol: protocol,
                   // );

                    // You can add further logic here if needed
                  } catch (e) {
                    print("Failed to configure VPN: $e");
                    // Handle errors or display a message to the user
                  }
                }
              },
              child: Container(
                width: 300,
                height: 300,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Port',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(port), // Display the 'port' value
                  ],
                ),
                SizedBox(width: 20), // Add spacing between columns
                Column(
                  children: [
                    Text(
                      'Protocol',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(protocol), // Display the 'protocol' value
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Rest of your code...

Future<bool> isDarkModeEnabled() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isToggleEnabled') ?? true;
}

void applyTheme(BuildContext context) async {
  // Load the dark mode preference
  bool isDarkMode = await isDarkModeEnabled();

  // Set the theme based on the opposite of the saved preference value
  ThemeData theme = isDarkMode ? lightTheme : darkTheme;

  runApp(MaterialApp(
    routes: {
      '/menu': (context) => MenuPage(),
    },
    debugShowCheckedModeBanner: false,
    theme: theme,
    home: HomePage(),
  ));
}

Future<String?> getState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('switch');
  return prefs.getString('port');
  return prefs.getString('protocol');
}

Future<void> saveState(String state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('switch', state);
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  // Customize your light theme here
  // Other theme properties...
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  // Customize your dark theme here
  // Other theme properties...
);
