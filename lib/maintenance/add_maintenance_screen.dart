import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMaintenanceScreen extends StatefulWidget {
  final String userId;

  const AddMaintenanceScreen({super.key, required this.userId});

  @override
  State<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends State<AddMaintenanceScreen> {
  TextEditingController amount = TextEditingController();
  TextEditingController dueDate = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void addData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var response = await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/add_maintenance.php"),
      body: {
        "user_id": widget.userId.toString(),
        "amount": amount.text.trim(),
        "due_date": dueDate.text.trim(),
      },
    );

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added Successfully")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Add Failed")));
    }
  }

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Maintenance"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration("Amount", Icons.currency_rupee),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter amount";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),
              TextFormField(
                controller: dueDate,
                readOnly: true,
                decoration: fieldDecoration("Due Date", Icons.date_range),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                    setState(() {
                      dueDate.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select due date";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: addData,
                  child: Text(
                    "Insert",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
