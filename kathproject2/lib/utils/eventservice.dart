import 'package:kathproject2/utils/event.dart';  
import 'favourite.dart';

class EventService {
  static List<Event> events = [
    Event(
      id: '1',
      title: 'Rock Concert',
      description: 'A night of amazing rock music!',
      date: DateTime(2025, 3, 15),
      price: 150.0,
      imageUrl: 'assets/concert.jpg',
    ),
    Event(
      id: '2',
      title: 'Comedy',
      description: 'A great day with the famous "Gila"',
      date: DateTime(2025, 5, 10),
      price: 10.0,
      imageUrl: 'assets/comedy.jpg',
    ),
    Event(
      id: '3',
      title: 'Art Expo',
      description: 'Modern art exhibition',
      date: DateTime(2024, 5, 12),
      price: 5.0,
      imageUrl: 'assets/expo.jpeg',
    ),
    Event(
      id: '4',
      title: 'Festivals in Valencia',
      description: 'Bigsound in July',
      date: DateTime(2021, 7, 1),
      price: 65.0,
      imageUrl: 'assets/festival.jpg',
    ),
  ];

  static Future<List<Event>> getEvents({
    bool filterByFavorites = false,
    bool showOnlyPastEvents = false,
    String? sortBy,
  }) async {
    List<Event> displayedEvents = List.from(events);

    if (filterByFavorites) {
      List<String> favoriteIds = await FavoritesService.getFavorites();
      displayedEvents = displayedEvents
          .where((event) => favoriteIds.contains(event.id))
          .toList();
    }

    if (showOnlyPastEvents) {
      displayedEvents = displayedEvents
          .where((event) => event.date.isBefore(DateTime.now()))
          .toList();
    } else {
      displayedEvents = displayedEvents
          .where((event) => event.date.isAfter(DateTime.now()))
          .toList();
    }

    if (sortBy == "date") {
      displayedEvents.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortBy == "price") {
      displayedEvents.sort((a, b) => a.price.compareTo(b.price));
    }

    return displayedEvents;
  }

  static Future<void> toggleFavorite(String eventId) async {
    await FavoritesService.toggleFavorite(eventId);
  }

static Future<void> deleteEvent(String eventId) async {
  events.removeWhere((event) => event.id == eventId);
}

}