import 'package:digital_society_admin/visitors/visitors_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class add_visitors extends StatefulWidget {
  const add_visitors({super.key});

  @override
  State<add_visitors> createState() => _add_visitorsState();
}

class _add_visitorsState extends State<add_visitors> {
  TextEditingController name = TextEditingController();
  TextEditingController flat_no = TextEditingController();
  TextEditingController visit_date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      appBar: AppBar(
        title: Text(
          "Add Visitor",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Visitor Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                TextFormField(
                  controller: flat_no,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Flat Number",
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                TextFormField(
                  controller: visit_date,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      visit_date.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Visit Date (YYYY-MM-DD)",
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                    onPressed: () {
                      String visitorname = name.text.trim();
                      String flatno = flat_no.text.trim();
                      String visitdate = visit_date.text.trim();

                      if (visitorname.isEmpty) {
                        showMessage("Please enter visitor name");
                        return;
                      }

                      if (flatno.isEmpty) {
                        showMessage("Please enter flat number");
                        return;
                      }

                      if (visitdate.isEmpty) {
                        showMessage("Please select visit date");
                        return;
                      }
                      RegExp dateRegex = RegExp(
                        r"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$",
                      );

                      if (!dateRegex.hasMatch(visitdate)) {
                        showMessage("Invalid date format (Use YYYY-MM-DD)");
                        return;
                      }
                      adddata(visitorname, flatno, visitdate);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitorsScreen(),
                        ),
                      );
                    },

                    child: Text(
                      "Insert Visitor",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void adddata(String visitorname, String flatno, String visitdate) async {
    var url = Uri.parse("https://prakrutitech.xyz/ankita/add_visitor.php");

    var resp = await http.post(
      url,
      body: {"name": visitorname, "flat_no": flatno, "visit_date": visitdate},
    );

    print(resp.statusCode);
    print("Visitor Added");
  }
}
