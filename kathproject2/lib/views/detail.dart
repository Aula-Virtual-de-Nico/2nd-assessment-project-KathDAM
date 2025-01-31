/*
Window Title: {event title} (where {event title} is the title of the displayed event).
• Shows the following information:
  o Title
  o Description
  o Date
  o Price
  o Image
  o Button to mark the event as a favorite (stores the event ID in local storage).
• Top Bar:
  o Button to return to the event list.
  o Button to edit the event.
  o Button to delete the event (with confirmation dialog).
  o Button to save the event as a favorite.
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kathproject2/views/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kathproject2/utils/event.dart';  

class DetailEvent extends StatelessWidget {
  final Event event;

  const DetailEvent({super.key, required this.event});

  Future<void> _markAsFavorite(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
   
  }

  _deleteEvent(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Event: ${event.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
           onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEvent(), 
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEvent(context),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _markAsFavorite(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${DateFormat('dd/MM/yyyy').format(event.date)}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: ${event.price.toStringAsFixed(2)} \€",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(event.imageUrl),
          ],
        ),
      ),
    );
  }
}
