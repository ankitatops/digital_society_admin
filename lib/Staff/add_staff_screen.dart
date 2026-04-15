import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  bool isLoading = false;

  String apiUrl = "https://prakrutitech.xyz/ankita/add_staff.php";

  Future addStaff() async {
    if (nameController.text.isEmpty || roleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter name and role")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
      Uri.parse(apiUrl),
      body: {"name": nameController.text, "role": roleController.text},
    );

    var data = jsonDecode(response.body);

    setState(() {
      isLoading = false;
    });

    if (data["status"] == "success") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Staff"),
        backgroundColor: Colors.blue.shade100,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Staff Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: "Staff Role",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),

                onPressed: isLoading ? null : addStaff,

                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Add Staff",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
