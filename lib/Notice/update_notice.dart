import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateNoticeScreen extends StatefulWidget {
  final String id;
  final String title;
  final String message;

  const UpdateNoticeScreen({
    super.key,
    required this.id,
    required this.title,
    required this.message,
  });

  @override
  State<UpdateNoticeScreen> createState() => _UpdateNoticeScreenState();
}

class _UpdateNoticeScreenState extends State<UpdateNoticeScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
    title.text = widget.title;
    message.text = widget.message;
  }

  Future updateNotice() async {
    print("Button Clicked");

    var response = await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/update_notice.php"),
      body: {
        "id": widget.id,
        "title": title.text,
        "message": message.text,
      },
    );

    print(response.body);

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title:  Text("Update Notice"),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin:  EdgeInsets.all(16),
            padding:  EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Update Notice",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: "Title",
                    prefixIcon: Icon(Icons.title, color: Colors.blue),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 15),
                TextField(
                  controller: message,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Message",
                    prefixIcon: Icon(Icons.message, color: Colors.blue),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: updateNotice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Update Notice",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}