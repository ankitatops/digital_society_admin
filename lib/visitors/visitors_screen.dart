import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_visitors.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  List visitors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    try {
      var response = await http.get(
        Uri.parse("https://prakrutitech.xyz/ankita/get_all_visitors.php"),
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          visitors = data["data"];
          isLoading = false;
        });
      } else {
        setState(() {
          visitors = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: Text("Visitors"),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: loadFeedback,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : visitors.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "No Visitors Found",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: visitors.length,
                        itemBuilder: (context, index) {
                          var visitor = visitors[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        visitor["id"],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10),

                                    Text(
                                      "ID: ${visitor["id"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                Text(
                                  visitor["name"] ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  "Flat No : ${visitor["flat_no"]}",
                                  style: TextStyle(color: Colors.black54),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "Visit Date : ${visitor["visit_date"]}",
                                  style: TextStyle(color: Colors.black54),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "Status : ${visitor["status"]}",
                                  style: TextStyle(color: Colors.black54),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "Created : ${visitor["created_at"]}",
                                  style: TextStyle(color: Colors.black45),
                                ),

                                SizedBox(height: 10),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      approveVisitor(visitor["id"].toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => add_visitors()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void approveVisitor(String id) async {
    try {
      var response = await http.post(
        Uri.parse("https://prakrutitech.xyz/ankita/approve_visitor.php"),
        body: {"id": id},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Visitor Approved")));

        loadFeedback();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Approval Failed")));
      }
    } catch (e) {
      print("Error:$e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Server Error")));
    }
  }
}
