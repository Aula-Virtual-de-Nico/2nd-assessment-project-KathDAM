import 'package:flutter/material.dart';
import 'creation.dart';
import 'detail.dart';
import 'edit.dart';
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
void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite_border_rounded),text: "Favorites"),
                Tab(icon: Icon(Icons.date_range_rounded), text: "Date"),
                Tab(icon: Icon(Icons.euro_symbol_rounded), text: "Price"),
                Tab(icon: Icon(Icons.event_available_rounded), text: "Past Events"),
            ],
            ),
            title: const Text('Event List'),
          ),
          body: const TabBarView(
            children: [
              //Preferencard, para hacer la lista de eventos, y estaran dentro de un grid-type
             /*const PreferenceCard(
              header: 'MY INTENSITY PREFERENCE',
              content: '🔥',
              preferenceChoices: [
                'Super heavy',
                'Dial it to 11',
                "Head bangin'",
                '1000W',
                'My neighbor hates me',
              ],
            ),
            */],
          ),
        ),
      ),
    );
  }
}