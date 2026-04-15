import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateEventPage extends StatefulWidget {
  final Map event;

  const UpdateEventPage({super.key, required this.event});

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  late TextEditingController title;
  late TextEditingController description;
  late TextEditingController date;

  @override
  void initState() {
    super.initState();

    title = TextEditingController(text: widget.event["title"]);
    description = TextEditingController(text: widget.event["description"]);
    date = TextEditingController(text: widget.event["event_date"]);
  }

  Future updateEvent() async {
    await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/update_event.php"),
      body: {
        "id": widget.event["id"],
        "title": title.text,
        "description": description.text,
        "event_date": date.text,
      },
    );

    Navigator.pop(context, true);
  }

  Widget inputField(controller, label) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),

      padding: EdgeInsets.symmetric(horizontal: 15),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(labelText: label, border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: Text("Update Event"),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Container(
          padding: EdgeInsets.all(20),

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
            children: [
              inputField(title, "Event Title"),

              inputField(description, "Description"),

              inputField(date, "Event Date"),

              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: updateEvent,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                  ),

                  child: Text(
                    "Update Event",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
