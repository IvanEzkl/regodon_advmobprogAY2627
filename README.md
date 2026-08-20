# Ivan Regodon 
## INF 231
## CTADMOBL Advance Mobile Programming

A Flutter Project that focuses on advance topics. Covering the Mobile to Web Transactions.

## Lab Activity 3
# Lab Activity 3: Discussion
## API PART II
This activity extends the app with a Cart feature using the DummyJSON API, following the same three-layer architecture: **Models**, **Services**, and **Screens**.
1. **Model Layer ( `lib/models/cart.dart` ):** Defines `Cart` and `CartProduct` using `fromJson` to convert JSON payloads into typed Dart objects.
2. **Service Layer ( `lib/services/cart_service.dart` ):** Handles API calls — `getCartByUserId()` fetches a user's cart via `GET /carts/user/{id}`, and `addToCart()` posts to `POST /carts/add`.
3. **Screen / UI Layer ( `lib/screens/cart_screen.dart` ):** Uses a `FutureBuilder` to render cart items. Tapping an item fetches the full product via `getProductById()` and navigates to the same `ProductDetailScreen` used in the product flow.
## Implemented Design Pattern
The activity follows the same **Provider Pattern with separation of concerns**, extended with a cart module:
- **Cart Module:** `cart.dart`, `cart_service.dart`, and `cart_screen.dart` mirror the existing product module structure.
- **Shared Navigation:** `ProductDetailScreen` is reused for both product browsing and cart item details, eliminating code duplication.
## Using getById at the Cart Endpoint
`GET /carts/user/{id}` returns carts belonging to a specific user. `getCartByUserId(1)` is called on `initState()` to simulate a logged-in user, and the first cart in the response is rendered in `CartScreen`.
