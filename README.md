# Ivan Regodon 
## INF 231
## CTADMOBL Advance Mobile Programming

A Flutter Project that focuses on advance topics. Covering the Mobile to Web Transactions.

## Lab Activity 1: Discussion

Lab Activity 1 -setState manages local, single-widget state by rebuilding the entire widget on each update, making it best for simple UI interactions like toggles. Provider handles app-wide state by separating business logic into dedicated models, boosting performance by rebuilding only the specific widgets listening to the changed data.

# Lab Activity 2: Discussion

Lab Activity 2 - This app uses a layered Model-Service-Screen architecture: Models parse JSON into typed objects, Services handle HTTP calls to the API, and Screens use FutureBuilder to load and display data asynchronously. State is managed via the Provider pattern, where ThemeProvider extends ChangeNotifier to toggle light/dark mode and update the UI reactively through notifyListeners().

# Lab Activity 3: Discussion

Lab Activity 3 - This activity extends the app with a Cart feature using the DummyJSON API, following the same three-layer architecture. The Model layer (cart.dart) defines Cart and CartProduct via fromJson; the Service layer (cart_service.dart) handles getCartByUserId() (GET /carts/user/{id}) and addToCart() (POST /carts/add); and the Screen layer (cart_screen.dart) uses FutureBuilder to render cart items, reusing ProductDetailScreen for item details. It follows the same Provider pattern with separation of concerns, and getCartByUserId(1) is called on initState() to simulate a logged-in user, rendering the first cart returned.
