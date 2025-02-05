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
import 'package:kathproject2/utils/event.dart';
import 'package:kathproject2/utils/favourite.dart';

class EditEvent extends StatefulWidget {
  final Event event;

  const EditEvent({super.key, required this.event});
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    bool favorite = await FavoritesService.isFavorite(widget.event.id);
    setState(() {
      isFavorite = favorite;
    });
  }
Future<void> _toggleFavorite() async {
    await FavoritesService.toggleFavorite(widget.event.id);
    _loadFavoriteStatus(); 
  }

   Future<void>_deleteEvent(BuildContext context) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
