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

## Lab Activity 4: Discussion

Lab Activity 4 - This update introduces a custom splash screen, branded sign-in flow, dynamic profile view, and global theme switcher, following the same three-layer architecture. The Model layer (user.dart) defines the User schema for credentials and session tokens; the Service layer (user_service.dart) handles POST /auth/login, token validation via GET /auth/me, and persistence through SharedPreferences; and the UI layer (profile_screen.dart) hydrates user data from local cache on initState() to avoid extra network calls. ThemeProvider manages global light/dark theming reactively via context.watch<ThemeProvider>(), while UserService serves as the single source of truth for auth state. The cart flow is user-scoped: after login, the user's id is saved to SharedPreferences, read by CartScreen on initState(), and used by CartService().getCartByUserId(id) to fetch and render the cart via FutureBuilder.
