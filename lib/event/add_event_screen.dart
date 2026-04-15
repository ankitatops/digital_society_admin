import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();

  File? imageFile;

  Future pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future addEvent() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://prakrutitech.xyz/ankita/add_event.php"),
    );

    request.fields['title'] = title.text;
    request.fields['description'] = description.text;
    request.fields['event_date'] = date.text;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );
    }

    await request.send();

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
        title: Text("Add Event"),
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

              Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: date,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Event Date",
                    border: InputBorder.none,
                  ),
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
                        date.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageFile == null
                    ? Center(child: Text("No Image Selected"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: pickImage,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                  ),

                  child: Text(
                    "Pick Image",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: addEvent,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                  ),

                  child: Text(
                    "Add Event",
                    style: TextStyle(color: Colors.black),
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
