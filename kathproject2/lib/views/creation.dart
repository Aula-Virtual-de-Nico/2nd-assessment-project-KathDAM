/*
  o Image Selector: Optional, displays an image file selector (image picker).
  o Image Preview: If an image is selected.
  o Create Button: Saves the event and returns to the list.
  o Discard Button: Shows a confirmation dialog; if confirmed, returns to the list
  without saving.
• Top Bar:
  o Button to return to the event list (shows a confirmation dialog if there are
unsaved changes).

*/
import 'dart:typed_data';
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
  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;
  

Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes(); // Convertir a bytes
    setState(() {
      _selectedImage = bytes; // Guardar la imagen en bytes
      _hasChanges = true;
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
        imageUrl: _selectedImage == null ? 'assets/plantilla.jpeg' : '',
        imageBytes: _selectedImage,
      );

      EventService.events.add(newEvent);
      widget.onEventCreated(newEvent);

      Navigator.pop(context);
    }
  }

  void _discardChanges() {
    if (!_hasChanges) {
    Navigator.pop(context);
    return;
    }

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
              Navigator.pop(context,true);
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
          width: screenWidth * 0.95, 
          height: screenHeight * 0.85, 
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
                    onChanged: (value) {
                      setState(() {
                        _hasChanges = true;
                      });
                    },
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
                     onChanged: (value) {
                      setState(() {
                        _hasChanges = true;
                      });
                    },
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
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Price (€)"),
                     onChanged: (value) {
                      setState(() {
                        _hasChanges = true;
                      });
                    },
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
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      _selectedDate == null
                          ? "Select Date"
                          : "Date :  ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  if (_selectedDate == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Date is required",
                        style: TextStyle(color: Color.fromARGB(255, 206, 30, 18)),
                      ),
                    ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Select Image"),
                      ),
                      SizedBox(
                        height: 250,
                        width: 180,
                        child: _selectedImage != null
                            ? Image.memory(_selectedImage!, fit: BoxFit.cover)
                            : Image.asset('assets/plantilla.jpeg', fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
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
                            backgroundColor: const Color.fromARGB(255, 236, 155, 149)),
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