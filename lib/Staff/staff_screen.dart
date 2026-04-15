import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_staff_screen.dart';
import 'assign_task.dart';

class staff extends StatefulWidget {
  const staff({super.key});

  @override
  State<staff> createState() => _staffState();
}

class _staffState extends State<staff> {
  List staff = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getstaff();
  }

  Future getstaff() async {
    var response = await http.get(
      Uri.parse("https://prakrutitech.xyz/ankita/get_all_staff.php"),
    );

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        staff = data["data"];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future deleteStaff(String id) async {
    var response = await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/delete_staff.php"),
      body: {"id": id},
    );

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      getstaff();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Staff Deleted")));
    }
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Staff"),
          content: Text("Are you sure you want to delete this notice?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                deleteStaff(id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Staff"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: RefreshIndicator(
        onRefresh: getstaff,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    var data = staff[index];

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    data["id"].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  data["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(data["role"]),
                                SizedBox(height: 10),
                                Text(
                                  data["created_at"],
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.assignment_rounded,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AssignTask(
                                              staffId: data["id"].toString(),
                                            ),
                                          ),
                                        ).then((value) => getstaff());
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(data["id"]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStaffScreen()),
          ).then((value) => getstaff());
        },
      ),
    );
  }
}
