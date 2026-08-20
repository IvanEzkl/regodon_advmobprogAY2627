# Ivan Regodon 
## INF 231
## CTADMOBL Advance Mobile Programming

A Flutter Project that focuses on advance topics. Covering the Mobile to Web Transactions.

# Lab Activity 4: UI/UX Enhancements & Profile Integration

This update introduces a custom splash screen, a branded sign-in flow, a dynamic profile view, and a global theme switcher built on a strict three-layer architecture.

---

## 🏗️ Architecture Overview

| Layer | Path | Responsibility |
| :--- | :--- | :--- |
| **Model** | `lib/models/user.dart` | Defines the `User` schema and handles JSON deserialization for credentials, profile data, and session tokens. |
| **Service** | `lib/services/user_service.dart` | Manages `POST /auth/login` requests, token validation via `GET /auth/me`, and persistent local storage through `SharedPreferences`. |
| **UI** | `lib/screens/profile_screen.dart` | Hydrates user details directly from local cache during `initState()` to eliminate unnecessary network overhead. |

---

## ⚙️ Implemented Design Patterns

### 1. Theme Management (`ThemeProvider`)
* Manages global app brightness using a central reactive state.
* `MaterialApp` listens via `context.watch<ThemeProvider>()` to hot-swap between branded light and dark theme data across all routes.

### 2. State & Auth Isolation (`UserService`)
* Acts as the single source of truth for session lifecycles.
* UI widgets remain purely presentational, consuming auth state without managing local credentials directly.

---

## 🛒 User-Scoped Cart Flow

[ User Logs In ] ──> [ ID Saved to SharedPreferences ]
│
▼
[ CartScreen: initState() ] ──> [ Read Stored ID ]
│
▼
[ CartService ] ─────────────> [ GET /carts/user/{id} ] ──> [ FutureBuilder UI ]

1. **Persistence:** The authenticated user's `id` is saved locally upon login.
2. **Data Fetching:** `CartScreen` reads the cached ID on initialization.
3. **Rendering:** `CartService().getCartByUserId(id)` fetches the corresponding dataset, rendering cart items dynamically through a `FutureBuilder`.
