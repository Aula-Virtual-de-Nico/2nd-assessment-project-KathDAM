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
import 'package:kathproject2/utils/eventservice.dart';
import 'package:kathproject2/views/creation.dart';
import 'package:kathproject2/views/detail.dart';
import 'package:intl/intl.dart';
import 'package:kathproject2/utils/event.dart';  


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool showPastEvents = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Event List'),
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.favorite_border_rounded),
                    text: "Favorites"),
                Tab(icon: Icon(Icons.date_range_rounded), text: "Date"),
                Tab(icon: Icon(Icons.euro_symbol_rounded), text: "Price"),
                Tab(
                    icon: Icon(Icons.event_available_rounded),
                    text: "Past Events"),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreationEvent()),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              buildEventGrid(filterByFavorites: true),
              buildEventGrid(sortBy: "date"),
              buildEventGrid(sortBy: "price"),
              buildEventGrid(showOnlyPastEvents: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEventGrid(
      {bool filterByFavorites = false,
      String? sortBy,
      bool showOnlyPastEvents = false}) {
    List<Event> displayedEvents = EventService.getEvents(
      filterByFavorites: filterByFavorites,
      sortBy: sortBy,
      showOnlyPastEvents: showOnlyPastEvents,
    );

    if (displayedEvents.isEmpty) {
      return const Center(child: Text("No events available."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: displayedEvents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final event = displayedEvents[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailEvent(event:event)));
          },
          child: Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(event.imageUrl, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(event.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text("📅 ${DateFormat('dd/MM/yyyy').format(event.date)}"),
                      Text("💰 ${event.price.toStringAsFixed(2)} \€"),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    EventService.favoriteEvents.contains(event.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: EventService.favoriteEvents.contains(event.id)
                        ? Colors.red
                        : null,
                  ),
                  onPressed: () {
                    setState(() {
                      EventService.toggleFavorite(event.id);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
