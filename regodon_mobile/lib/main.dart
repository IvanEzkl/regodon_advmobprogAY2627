import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// screens
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

// providers
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) async {
      await dotenv.load(fileName: 'assets/.env');
      runApp(const RoblesAdvMobProg());
    },
  );
}

class RoblesAdvMobProg extends StatelessWidget {
  const RoblesAdvMobProg({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ScreenUtilInit(
        designSize: const Size(412, 715),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeModel = context.watch<ThemeProvider>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce App',
            // Enhancement 3: Dynamically switch light/dark theme using ThemeProvider
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF655A7C),       // Dolphin
                onPrimary: Color(0xFFFDF1E2),      // Linen (text on primary)
                secondary: Color(0xFFAB92BF),      // Amethyst
                onSecondary: Color(0xFFFDF1E2),    // Linen (text on secondary)
                surface: Color(0xFFFDF1E2),        // Linen (cards, surfaces)
                onSurface: Color(0xFF655A7C),      // Dolphin (text on surface)
                onSurfaceVariant: Color(0xFFAB92BF), // Amethyst (secondary text)
                outline: Color(0xFFAB92BF),        // Amethyst (borders)
                outlineVariant: Color(0xFFE8DCF0), // light amethyst (dividers)
              ),
              scaffoldBackgroundColor: const Color(0xFFFDF1E2),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF655A7C),
                foregroundColor: Color(0xFFFDF1E2),
                elevation: 2,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color(0xFF655A7C),
                selectedItemColor: Color(0xFFFDF1E2),
                unselectedItemColor: Color(0xFFAB92BF),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF655A7C),
                  foregroundColor: const Color(0xFFFDF1E2),
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF655A7C),
                foregroundColor: Color(0xFFFDF1E2),
              ),
              cardTheme: const CardThemeData(
                color: Color(0xFFFDF1E2),
              ),
              snackBarTheme: const SnackBarThemeData(
                backgroundColor: Color(0xFF655A7C),
                contentTextStyle: TextStyle(color: Color(0xFFFDF1E2)),
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/home',
            routes: {
              '/home': (context) => const HomeScreen(),
              // Enhancement 3: Route for Settings Screen
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}