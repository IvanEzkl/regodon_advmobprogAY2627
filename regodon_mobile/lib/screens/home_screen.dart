import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import '../widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, this.username = ''});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // 0 = Shop, 1 = Cart, 2 = Profile
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onTappedBar(int value) {
    setState(() => _selectedIndex = value);
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2,
          title: (_selectedIndex == 0)
              ? SizedBox(
                  height: 28.h,
                  child: Image.asset(
                    'assets/images/nubdexchange_logo.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    errorBuilder: (context, error, stackTrace) => CustomText(
                      text: 'NubdExchange',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : CustomText(
                  text: (_selectedIndex == 1)
                      ? 'Cart'
                      : (_selectedIndex == 2)
                          ? 'Profile'
                          : 'Home',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 24.sp),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (page) {
            setState(() => _selectedIndex = page);
          },
          children: const <Widget>[
            ProductScreen(),
            CartScreen(),
            Center(child: Text('Profile Screen')),
          ],
        ),
        // Enhancement 2: Chat bottom nav becomes a FloatingActionButton.
        // Hidden when the user is on the CartScreen (index 1).
        floatingActionButton: _selectedIndex == 1
            ? null
            : FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat coming soon!')),
                  );
                },
                backgroundColor: const Color(0xFF655A7C),
                child: const Icon(Icons.chat, color: Colors.white),
              ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onTappedBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shop_2), label: 'Shop'),
            // Enhancement 2: Cart replaces Chat in the bottom nav
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}