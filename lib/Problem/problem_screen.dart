import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  List allProblems = [];
  List solvedProblems = [];
  List pendingProblems = [];

  bool loading = true;

  String getUrl = "https://prakrutitech.xyz/ankita/get_problems.php";
  String updateUrl =
      "https://prakrutitech.xyz/ankita/update_problem_status.php";

  @override
  void initState() {
    super.initState();
    getProblems();
  }

  Future<void> getProblems() async {
    setState(() {
      loading = true;
    });

    var response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List temp = data["data"];
      print(temp);
      setState(() {
        allProblems = temp;
        solvedProblems = temp.where((p) {
          String status = p["status"].toString().trim().toLowerCase();
          return status == "closed" || status == "";
        }).toList();

        pendingProblems = temp.where((p) {
          String status = p["status"].toString().trim().toLowerCase();
          return status == "open" || status == "pending";
        }).toList();

        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future updateStatus(String id, String status) async {
    var response = await http.post(
      Uri.parse(updateUrl),
      body: {"id": id, "status": status},
    );

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      getProblems();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Problem Status Updated")));
    }
  }

  Widget buildList(List list) {
    if (list.isEmpty) {
      return Center(child: Text("No Data"));
    }

    return RefreshIndicator(
      onRefresh: getProblems,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          var problem = list[index];

          String status = problem["status"].toString().trim().toLowerCase();

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                Text(
                  problem["problem"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                Text("User ID : ${problem["user_id"]}"),

                SizedBox(height: 5),

                Text(
                  "Status : $status",
                  style: TextStyle(
                    color: (status == "closed" || status == "solved")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (status == "open" || status == "pending")
                          ? Colors.red
                          : Colors.green,
                    ),
                    onPressed: () {
                      String newStatus =
                          (status == "open" || status == "pending")
                          ? "closed"
                          : "open";

                      updateStatus(problem["id"].toString(), newStatus);
                    },
                    child: Text(
                      (status == "open" || status == "pending")
                          ? "Close"
                          : "Open",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,

        appBar: AppBar(
          title: Text("Problems List"),
          backgroundColor: Colors.blue.shade100,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Solved"),
              Tab(text: "Pending"),
            ],
          ),
        ),

        body: loading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  buildList(allProblems),
                  buildList(solvedProblems),
                  buildList(pendingProblems),
                ],
              ),
      ),
    );
  }
}
