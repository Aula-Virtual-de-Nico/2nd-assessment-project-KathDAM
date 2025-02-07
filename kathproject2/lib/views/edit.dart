/*
• Window Title: "Editing {event title}" (where {event title} is the title of the event being
edited).
• Displays a form similar to the creation view, pre-filled with the event's data.
  o The same validations as the creation view apply.
  o Remove Image Button: Deletes the selected image.
  o Save Button: Enabled if changes are made. Saves the changes and returns to the
  list.
  o Back Button: If there are unsaved changes, shows a confirmation dialog with the
following options:
    ▪ Message: Indicates unsaved changes.
    ▪ Save Button: Saves changes and returns to the list.
    ▪ Discard Button: Does not save changes and returns to the list.
    ▪ Cancel Button: Closes the dialog and remains in the edit view
 */

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kathproject2/utils/event.dart';
import 'package:kathproject2/utils/eventservice.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  final Function(Event) onEventUpdated;

  const EditEvent(
      {super.key, required this.event, required this.onEventUpdated});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  late DateTime _selectedDate;
  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _priceController =
        TextEditingController(text: widget.event.price.toString());
    _selectedDate = widget.event.date;
    _selectedImage = widget.event.imageBytes;
  }

  void _detectChanges() {
    if (_titleController.text != widget.event.title ||
        _descriptionController.text != widget.event.description ||
        _priceController.text != widget.event.price.toString() ||
        _selectedDate != widget.event.date ||
        _selectedImage != widget.event.imageBytes) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes;
        _hasChanges = true;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _hasChanges = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hasChanges = true;
      });
    }
  }

 void _saveEvent() async {
  if (_formKey.currentState!.validate()) {
    final updatedEvent = Event(
      id: widget.event.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      price: double.parse(_priceController.text),
      imageUrl: '', 
      imageBytes: _selectedImage,
    );

    await EventService.updateEvent(updatedEvent); 
    widget.onEventUpdated(updatedEvent); 

    Navigator.pop(context, updatedEvent); 
  }
}

  Future<void> _confirmDiscardChanges() async {
    final bool? shouldDiscard = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unsaved Changes"),
        content: const Text(
            "You have unsaved changes. Do you want to save before leaving?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _saveEvent();
              Navigator.pop(context, true);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Discard"),
          ),
        ],
      ),
    );

    if (shouldDiscard == true) {
      Navigator.pop(context);
    }
  }

  void _handleBackNavigation() {
    if (_hasChanges) {
      _confirmDiscardChanges();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackNavigation();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editing ${widget.event.title}"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackNavigation,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
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
                        : "Date :  ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Select Image"),
                    ),
                    if (_selectedImage != null) ...[
                      SizedBox(
                        height: 250,
                        width: 180,
                        child: Image.memory(_selectedImage!, fit: BoxFit.cover),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _removeImage,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _hasChanges ? _saveEvent : null,
                      child: const Text("Save Changes"),
                    ),
                    ElevatedButton(
                      onPressed: _handleBackNavigation,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 236, 155, 149)),
                      child: const Text("Discard"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
