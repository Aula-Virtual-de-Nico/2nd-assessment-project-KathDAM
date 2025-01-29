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