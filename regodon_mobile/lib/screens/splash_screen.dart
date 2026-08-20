import 'package:flutter/material.dart';
import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  late AnimationController _loaderController;

  @override
  void initState() {
    super.initState();

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Use addPostFrameCallback so the widget is fully in the tree before
    // any navigation attempt is made — prevents "stuck on splash" bugs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2200));
      if (!mounted) return;

      final loggedIn = await _userService.isLoggedIn();
      if (!mounted) return;

      if (loggedIn) {
        final userData = await _userService.getUserData();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home', arguments: userData);
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } catch (_) {
      // On any error (e.g. SharedPreferences failure), fall back to sign-in
      if (mounted) Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Match sample output: white background, logo, name text, gold loader
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/nubdexchange_logo.png',
              width: 160,
              filterQuality: FilterQuality.high,
            ),

            const SizedBox(height: 16),

            // App name — matches sample output text
            const Text(
              'NUBD Exchange',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 36),

            // Three-bar loader — gold colour matches logo accent
            AnimatedBuilder(
              animation: _loaderController,
              builder: (context, _) {
                return _ThreeBarLoader(
                  progress: _loaderController.value,
                  barColor: const Color(0xFFC8962A),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Replicates the CSS `l1` keyframe animation:
///   0%   → all bars full height
///   33%  → bar 0 short, bars 1-2 full
///   50%  → bar 1 short, bars 0 & 2 full
///   66%  → bar 2 short, bars 0-1 full
///   100% → all bars full height
class _ThreeBarLoader extends StatelessWidget {
  const _ThreeBarLoader({
    required this.progress,
    required this.barColor,
  });

  final double progress;
  final Color barColor;

  double _barHeight(int barIndex) {
    const centres = [0.33, 0.50, 0.66];
    const halfWindow = 0.085;
    const minH = 0.10;
    const maxH = 1.00;

    final centre = centres[barIndex];
    final dist = (progress - centre).abs();
    final wrappedDist = dist > 0.5 ? 1.0 - dist : dist;

    if (wrappedDist >= halfWindow) return maxH;

    final t = wrappedDist / halfWindow;
    final eased = Curves.easeInOut.transform(t);
    return minH + (maxH - minH) * eased;
  }

  @override
  Widget build(BuildContext context) {
    const totalWidth = 45.0;
    const totalHeight = 45.0;
    const barW = totalWidth * 0.20;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (i) {
          final hFraction = _barHeight(i);
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: barW,
              height: totalHeight * hFraction,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
