import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Dashborad/dashborad.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool isAdmin = sharedPreferences.getBool('admin') ?? false;

    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/bgimg.png", fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 70,
                            color: Colors.brown.shade100,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Admin Login",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade100,
                            ),
                          ),

                          SizedBox(height: 30),

                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Email";
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return "Enter valid email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Colors.blue.shade100,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blueGrey.shade100,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Password";
                              }
                              if (value.length < 6) {
                                return "Min 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.blue.shade100,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blueGrey.shade100,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  logindata();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white.withOpacity(0.5),
                              ),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logindata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var response = await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/login.php"),
      body: {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      },
    );

    var data = json.decode(response.body);

    if (data["status"] == "success") {
      if (data["data"]["role"] == "admin") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Admin Login Successful'),
            backgroundColor: Colors.green,
          ),
        );

        await sharedPreferences.setBool('admin', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Only Admin allowed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"]), backgroundColor: Colors.red),
      );
    }
  }
}
