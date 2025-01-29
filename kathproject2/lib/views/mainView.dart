/*
View Title: "Event List"
• Displays a grid-type list of events. By default, past events (prior to the current date) will
not be displayed.
  o Each item in the list will show the following information:
    o Title
    o Description
    o Date
    o Price
    o Image
  o Button to mark the event as a favorite (stores the event ID in local storage).
• Clicking on a list item opens a new page showing the details of the selected event.
• List Controls:
  o Filter events by "favorites."
  o Sort events by "date."
  o Sort events by "price."
  o Show/hide past events (prior to the current date).
• Top Bar:
  o Button to create a new event
  Para ver ejemplos https://flutter.github.io/samples/material_3.html
 */
import 'package:flutter/material.dart';
import 'package:kathproject2/views/creation.dart';

void main() {
  runApp(const MainView());
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite_border_rounded), text: "Favorites"),
                Tab(icon: Icon(Icons.date_range_rounded), text: "Date"),
                Tab(icon: Icon(Icons.euro_symbol_rounded), text: "Price"),
                Tab(icon: Icon(Icons.event_available_rounded), text: "Past Events"),
              ],
            ),
            title: const Text('Event List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const CreationEvent()),
                  );
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              //cambiarlo por grid-type list of events 
              Center(child: Text('Favorites Tab')),
              Center(child: Text('Date Tab')),
              Center(child: Text('Price Tab')),
              Center(child: Text('Past Events Tab')),
              
            ],
          ),
        ),
      ),
    );
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double price;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.imageUrl,
  });
}