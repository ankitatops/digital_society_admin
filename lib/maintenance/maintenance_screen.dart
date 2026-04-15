import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserMaintenanceScreen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      var response = await http.get(
        Uri.parse("https://prakrutitech.xyz/ankita/get_all_users.php"),
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          users = data["data"];
        });
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];

            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserMaintenanceScreen(
                        userId: user["id"].toString(),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          user["name"]
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["name"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "ID: ${user["id"]}",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}