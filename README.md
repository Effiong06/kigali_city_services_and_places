****Kigali City Services & Places****

**A comprehensive Flutter mobile application for discovering and navigating local services in Kigali, Rwanda. This project demonstrates real-time cloud integration, clean architectural patterns, and robust state management.**


**Features**
______________________________
 
  1.) User Authentication: Secure sign-up and login powered by Firebase Authentication;

  2.) Dynamic Service Discovery: Real-time list of hospitals, cafes, and hotels fetched from Cloud Firestore;

  3.) CRUD Operations: Authorized users can add, update, or remove service listings directly from the app;

  4.) Embedded Mapping: Interactive Kigali map view for every service using flutter_map;

  5.) Navigation Intent: One-tap button to launch external navigation (Google Maps) for any chosen location.
____________________________________________________________________________________________________________________________________

**Architectural Structure**
______________________________________

*The project follows a Clean Architecture approach to ensure the code is maintainable and testable. The lib/ directory is organized into five primary layers:*


 models/: The Data Layer. Defines data entities (e.g., ServiceListing) that structure how Kigali services are represented in the app.
 
 services/: The Infrastructure Layer. Contains FirestoreService and AuthService to handle all backend communication and API calls.
 
 providers/: The State Management Layer. Contains the logic for managing app state and notifying the UI of data changes (using Provider/Riverpod).
 
 screens/: The Presentation Layer (Pages). High-level Flutter widgets that represent entire views, such as Home, Details, and Auth screens.
 
 widgets/: The Presentation Layer (Components). Reusable UI components and smaller building blocks used across multiple screens to keep the code DRY.
_______________________________________________________________________________________________________________

**Firestore Database Structure**
________________________________________

*The application utilizes a NoSQL document-oriented structure in Cloud Firestore.*

  Collection: listings
    
    Each document represents a unique city service identified by a unique ID.
    
    Fields:
    
      name (String): The display name of the service.
      
      category (String): Category filter (e.g., "Health", "Food").
      
      description (String): Detailed info about the service.
      
      latitude (Double): Geographic latitude for map positioning.
      
      longitude (Double): Geographic longitude for map positioning.
____________________________________________________________________________________________

**State Management**
____________________________
This project uses the Provider package for state management.

Why Provider? It allows for a clean "Separation of Concerns." The UI (Screens) never talks directly to the Database. Instead, it listens to a ListingProvider.

The Flow: When a user adds a new service, the ListingProvider calls the FirestoreService, waits for the cloud update, and then calls notifyListeners(). This automatically rebuilds the list on the user's screen without a manual refresh.
