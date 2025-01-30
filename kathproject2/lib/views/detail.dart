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

class DetailEvent extends StatelessWidget {
  const DetailEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Event: '),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
           //info
            print('Detalle mostrado');
          },
          child: const Text('Details event'),
        ),
      ),
    );
  }
}