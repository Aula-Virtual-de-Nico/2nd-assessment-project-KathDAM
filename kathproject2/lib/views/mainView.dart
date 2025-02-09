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
import 'package:intl/intl.dart';
import 'package:kathproject2/utils/eventservice.dart';
import 'package:kathproject2/utils/favourite.dart';
import 'package:kathproject2/views/creation.dart';
import 'package:kathproject2/views/detail.dart';
import 'package:kathproject2/utils/event.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // Variable para saber si los favoritos están actualizados
  bool _favoritesUpdated = false;

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
                Tab(icon: Icon(Icons.favorite_border_rounded), text: "Favorites"),
                Tab(icon: Icon(Icons.date_range_rounded), text: "Date"),
                Tab(icon: Icon(Icons.euro_symbol_rounded), text: "Price"),
                Tab(icon: Icon(Icons.event_available_rounded), text: "Past Events"),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreationEvent(
                      onEventCreated: (newEvent) {
                        setState(() {});
                      },
                    )),
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
  // Recargar favoritos cada vez que la vista se reconstruya
  Widget buildEventGrid({
    bool filterByFavorites = false,
    String? sortBy,
    bool showOnlyPastEvents = false,
  }) {
    return FutureBuilder<List<Event>>(
      future: EventService.getEvents(
        filterByFavorites: filterByFavorites,
        sortBy: sortBy,
        showOnlyPastEvents: showOnlyPastEvents,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No events available."));
        }

        List<Event> displayedEvents = snapshot.data!;

        return FutureBuilder<List<String>>(
          future: FavoritesService.getFavorites(),
          builder: (context, favSnapshot) {
            if (!favSnapshot.hasData) return const SizedBox.shrink();

            List<String> favoriteEvents = favSnapshot.data!;

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
                bool isFavorite = favoriteEvents.contains(event.id);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailEvent(event: event),
                      ),
                    ).then((value) {
                      if (value != null && value is Event) {
                        setState(() {}); // Recargamos lo editado
                      }
                      setState(() {
                        // Recargamos favoritos después de volver de los detalles
                        _favoritesUpdated = true;
                      });
                    });
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                           child: event.imageBytes != null
                                ? Image.memory(event.imageBytes!, fit: BoxFit.cover)
                                : event.imageUrl.startsWith('assets/')
                                    ? Image.asset(event.imageUrl, fit: BoxFit.cover)
                                    : Image.network(event.imageUrl, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                              Text("📅 ${DateFormat('dd/MM/yyyy').format(event.date)}"),
                              Text("💰 ${event.price.toStringAsFixed(2)} \€"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () async {
                            await EventService.toggleFavorite(event.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
