# Ivan Regodon 
## INF 231
## CTADMOBL Advance Mobile Programming

A Flutter Project that focuses on advance topics. Covering the Mobile to Web Transactions.

## Lab Activity 2

# Lab Activity 2: Discussion

## Architectural Flow & API Endpoint Rendering
This application implements a modular architecture composed of three main layers: **Models**, **Services**, and **Screens**.

1. **Model Layer (`lib/models/product.dart`)**: Defines data structures and parsing logic (via `fromJson` factory constructors) to convert JSON payloads into strongly typed Dart objects.
2. **Service Layer (`lib/services/product_service.dart`)**: Manages external network communication using HTTP GET requests sent to the REST API (`$host/products`). It handles status codes and parses the response body into usable model objects.
3. **Screen / UI Layer (`lib/screens/`)**: Uses a `FutureBuilder` inside dynamic widgets (like `GridView.builder`) to asynchronously await data from `ProductService`. While waiting, it displays dynamic loading indicators, and renders product dynamic grids once state settles.

## Implemented Design Pattern
This project follows the **Provider Pattern with State Management (ChangeNotifier)** along with a clean separation of concerns:
* **State Management**: `ThemeProvider` extends `ChangeNotifier` to hold the light/dark mode state. When toggled via `SettingsScreen`, `notifyListeners()` updates the MaterialApp reactive scope without needing complex parent-child callbacks.
* **Feature Module Organization**: Code is logically structured into dedicated folders (`models/`, `providers/`, `screens/`, `services/`, `widgets/`) ensuring clear code readability, scalability, and ease of maintenance.
