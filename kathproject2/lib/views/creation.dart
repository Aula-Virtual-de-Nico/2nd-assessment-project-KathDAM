/*
• Window Title: "New Event."
• Displays a form to create a new event with the following elements:
  o Title Input: Required, between 5 and 50 characters.
  o Description Input: Optional, between 5 and 255 characters.
  o Date Selector: Required, must be the current date or later (with a date picker to
  select the date).
  o Price Input: Required, default is 0, cannot be negative.
  o Image Selector: Optional, displays an image file selector (image picker).
  o Image Preview: If an image is selected.
  o Create Button: Saves the event and returns to the list.
  o Discard Button: Shows a confirmation dialog; if confirmed, returns to the list
  without saving.
• Top Bar:
  o Button to return to the event list (shows a confirmation dialog if there are
unsaved changes).

*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kathproject2/utils/eventservice.dart';
import 'package:kathproject2/utils/event.dart';

class CreationEvent extends StatefulWidget {
  final Function(Event) onEventCreated;

  const CreationEvent({super.key, required this.onEventCreated});

  @override
  _CreationEventState createState() => _CreationEventState();
}

class _CreationEventState extends State<CreationEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: "0");

  DateTime? _selectedDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        price: double.parse(_priceController.text),
        imageUrl: _selectedImage?.path ?? '',
      );

      EventService.events.add(newEvent);
      widget.onEventCreated(newEvent);

      Navigator.pop(context);
    }
  }

  void _discardChanges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard Changes?"),
        content: const Text("Are you sure you want to discard changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Discard"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _discardChanges,
        ),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.5, // Ocupa la mitad del ancho de la pantalla
          height: screenHeight * 0.6, // Ocupa el 60% de la altura
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Title is required";
                      }
                      if (value.length < 5 || value.length > 50) {
                        return "Title must be between 5 and 50 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length < 5 || value.length > 255) {
                          return "Description must be between 5 and 255 characters";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      _selectedDate == null
                          ? "Select Date"
                          : "Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  if (_selectedDate == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Date is required",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Price (€)"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Price is required";
                      }
                      final double? price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return "Price must be a non-negative number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Select Image"),
                      ),
                      const SizedBox(width: 10),
                      if (_selectedImage != null)
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.file(_selectedImage!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _saveEvent,
                        child: const Text("Create"),
                      ),
                      ElevatedButton(
                        onPressed: _discardChanges,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("Discard"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}