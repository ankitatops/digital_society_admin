import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'update_event.dart';

class EventDetailsPage extends StatelessWidget {
  final Map event;

  const EventDetailsPage({super.key, required this.event});

  Future deleteEvent() async {
    try {
      await http.post(
        Uri.parse("https://prakrutitech.xyz/ankita/delete_event.php"),
        body: {"id": event["id"].toString()},
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://prakrutitech.xyz/ankita/uploads/events/${event["image"]}";

    return Scaffold(
      appBar: AppBar(
        title: Text(event["title"] ?? "Event Details"),
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateEventPage(event: event),
                ),
              );
              if (updated == true) Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete"),
                  content: Text("Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await deleteEvent();
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                      child: Text("Yes", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 200, maxHeight: 400),
              color: Colors.black12,
              child: (event["image"] == null || event["image"] == "")
                  ? Icon(Icons.image_not_supported, size: 100)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.broken_image, size: 80)),
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event["title"] ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Date: ${event["event_date"]}",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  Divider(height: 30),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    event["description"] ?? "",
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
