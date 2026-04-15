import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_event_screen.dart';
import 'event_details.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  Future getEvents() async {
    var response = await http.get(
      Uri.parse("https://prakrutitech.xyz/ankita/get_events.php"),
    );

    var data = jsonDecode(response.body);

    if (data["status"] == "success") {
      setState(() {
        events = data["data"];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: Text("All Events"),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.add),

        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEventPage()),
          );

          if (result == true) {
            getEvents();
          }
        },
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(12),

              itemCount: events.length,

              itemBuilder: (context, index) {
                var e = events[index];

                String imageUrl =
                    "https://prakrutitech.xyz/ankita/uploads/events/${e["image"]}";

                return GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsPage(event: e),
                      ),
                    );

                    if (result == true) {
                      getEvents();
                    }
                  },

                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),

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
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),

                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e["title"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                e["description"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.blue,
                                  ),

                                  SizedBox(width: 6),
                                  Text(
                                    e["event_date"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
