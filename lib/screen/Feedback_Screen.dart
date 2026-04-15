import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    try {
      var response = await http.get(
        Uri.parse("https://prakrutitech.xyz/ankita/get_feedback.php"),
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          feedbackList = data["data"];
          isLoading = false;
        });
      } else {
        setState(() {
          feedbackList = [];
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
        title: Text("User Feedback"),
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
                  : feedbackList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "No Feedback Found",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: feedbackList.length,

                        itemBuilder: (context, index) {
                          var feedback = feedbackList[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                        feedback["user_id"],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10),

                                    Text(
                                      "User ID: ${feedback["user_id"]}",
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
                                  feedback["message"] ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    feedback["date"] ?? "",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
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
    );
  }
}
