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
import 'package:kathproject2/utils/eventservice.dart';
import 'package:kathproject2/utils/favourite.dart';
import 'package:kathproject2/views/edit.dart';
import 'package:kathproject2/utils/event.dart';

class DetailEvent extends StatefulWidget {
  final Event event;
  
  const DetailEvent({super.key, required this.event});
  
  @override
  _DetailEventState createState() => _DetailEventState();
}
class _DetailEventState extends State<DetailEvent> {
  bool isFavorite = false;
  late Event currentEvent;

  @override
  void initState() {
    super.initState();
    currentEvent = widget.event;
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

Future<void> _deleteEvent(BuildContext context) async {
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

  if (confirmDelete == true) {
    try {
      await EventService.deleteEvent(widget.event.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Event: ${widget.event.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEvent(
                    event: widget.event,
                    onEventUpdated: (updatedEvent){
                      setState(() {
                       currentEvent = updatedEvent;
                      });
                    },),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEvent(context),
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${DateFormat('dd/MM/yyyy').format(widget.event.date)}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: ${widget.event.price.toStringAsFixed(2)} \€",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: widget.event.imageBytes != null
                    ? Image.memory(
                        widget.event.imageBytes!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      )
                    : Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
