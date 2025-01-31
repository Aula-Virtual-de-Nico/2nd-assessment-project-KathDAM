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

import 'package:flutter/material.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
           //info
            print('Evento editado');
          },
          child: const Text('Edit event'),
        ),
      ),
    );
  }
}