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

import 'package:flutter/material.dart';

class CreationEvent extends StatelessWidget {
  const CreationEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
           //info
            print('Evento creado');
          },
          child: const Text('Create event'),
        ),
      ),
    );
  }
}

/**
 import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreationEvent extends StatefulWidget {
  const CreationEvent({super.key});

  @override
  State<CreationEvent> createState() => _CreationEventState();
}

class _CreationEventState extends State<CreationEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _price = 0.0;
  File? _image;

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para seleccionar la imagen desde la galería
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Método para guardar el evento
  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes manejar el guardado del evento, por ejemplo, agregándolo a una lista o base de datos.
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
    }
  }

  // Método para mostrar el diálogo de confirmación de descartar cambios
  Future<bool> _discardChanges(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Discard Changes"),
              content: const Text("Are you sure you want to discard the changes?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Discard'),
                ),
              ],
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (_titleController.text.isNotEmpty ||
                _descriptionController.text.isNotEmpty ||
                _image != null ||
                _price != 0.0 ||
                _selectedDate != DateTime.now()) {
              bool discard = await _discardChanges(context);
              if (discard) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título del evento
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length < 5 || value.length > 50) {
                    return 'Title must be between 5 and 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Descripción del evento
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Event Description'),
                maxLength: 255,
                validator: (value) {
                  if (value != null && value.length < 5) {
                    return 'Description must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selector de fecha
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Precio del evento
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Price'),
                keyboardType: TextInputType.number,
                initialValue: '0.0',
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  if (double.tryParse(value) == null || _price < 0) {
                    return 'Price must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selector de imagen
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Image'),
                  ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.file(
                        _image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Botón para crear el evento
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 */