# 🎯 Event Manager App (KathProject2)

## 📱 Overview

**Event Manager App** is a Flutter-based mobile application designed to manage events effortlessly. The app allows users to create, view, edit, delete, and mark events as favorites. It provides an intuitive interface with multiple tabs for easy navigation and event management.

---

## 🚀 Features

### 🗂️ **Tabbed Navigation**

The main screen is divided into four mobile-friendly tabs:
1. **Favorites:** Displays all events marked as favorites.
2. **Past Events:** Shows events with dates earlier than today.
3. **Sorted by Date:** Lists upcoming events from the closest to the furthest date.
4. **Sorted by Price:** Displays events in ascending order of price.

You can easily switch between tabs to find specific events based on your preferences.

---

### ➕ **Creating New Events**

- A **"+" button** located at the top right corner allows users to create new events.
- The creation form includes fields for:
  - **Title** (5–50 characters)
  - **Description** (optional, 5–255 characters)
  - **Price** (non-negative values)
  - **Date** (cannot be in the past)
  - **Image** (optional)
- If no image is selected, a **default placeholder image (`plantilla.jpeg`)** is assigned to prevent exceptions.

---

### 🔍 **Viewing Event Details**

Clicking on any event opens the **Event Details View**, which displays:
- **Event Title, Description, Date, Price, and Image**
- Options to:
  - **Mark/Unmark as Favorite**
  - **Edit Event**
  - **Delete Event**

---

### ✏️ **Editing Events**

- The edit screen pre-fills the form with the current event’s data.
- Users can:
  - Update event details
  - **Remove the existing image** (if desired)
  - Add a new image if the previous one was deleted
- **Change Detection:** The **"Save Changes"** button activates only when modifications are made.

When navigating back with unsaved changes:
- A **confirmation dialog** appears with options to:
  - **Save** changes
  - **Discard** changes
  - **Cancel** and remain on the edit screen

---

## 📋 Predefined Events

The app comes with **4 predefined events** for demonstration purposes, managed within the `EventService` class:

```dart
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
}

---

## ⚙️ Implementation Details

### 1️⃣ **Event Model (`event.dart`)**
Defines the event structure with properties like `id`, `title`, `description`, `date`, `price`, `imageUrl`, and `imageBytes` (for dynamically uploaded images).

### 2️⃣ **Event Service (`eventservice.dart`)**
Handles business logic such as:
- **CRUD Operations:** Add, edit, delete events
- **Favorites:** Mark/unmark events as favorites
- **Sorting & Filtering:** By date, price, and favorites

### 3️⃣ **Image Handling**
- Supports both static asset images and images picked from the gallery.
- **Default Image Handling:** If no image is selected during event creation, `plantilla.jpeg` is used to prevent null exceptions.

### 4️⃣ **Form Validations**
- Title and description have character limits.
- Price must be a valid number ≥ 0.
- Date cannot be in the past.

---

## 🚧 Challenges Faced

1. **Image Persistence:**  
   **Issue:** Displaying the correct image when editing an event.  
   **Solution:** Managed both `imageBytes` (for gallery images) and `imageUrl` (for asset images), ensuring proper rendering.

2. **Unsaved Changes Prompt:**  
   **Issue:** Detecting unsaved changes reliably when navigating back.  
   **Solution:** Implemented listeners on form fields and tracked changes in images and dates.

3. **Date Validation:**  
   **Issue:** Preventing users from selecting past dates.  
   **Solution:** Restricted the date picker to start from the current date.

4. **Tab Navigation State:**  
   **Issue:** Ensuring tabs reflect real-time data after event creation or deletion.  
   **Solution:** Implemented state refresh callbacks across screens.

---

## 💡 Design Decisions

- **Simple State Management:** Used `setState()` for straightforward UI updates.
- **Modular Code:** Split screens into reusable widgets and services to maintain clean code.
- **User Experience:** Confirmation dialogs, default images, and validation feedback improve app reliability and user satisfaction.

---

## 🚀 How to Run the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/event-manager-app.git
   cd event-manager-app
   - Install dependencies: flutter pub get
   -Run the app: flutter run


