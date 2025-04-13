import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/game_state.dart';
import 'screens/game_screen.dart';
import 'screens/loading_screen.dart';

void main() {
  // Initialize web-specific configurations
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Potion Kitchen',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF8B4513), // Saddle Brown
            secondary: const Color(0xFF9370DB), // Medium Purple
            background: const Color(0xFF2F4F4F), // Dark Slate Gray
            surface: const Color(0xFF3D5A5A), // Darker Slate
            tertiary: const Color(0xFFFFD700), // Gold
            error: const Color(0xFFFF4500), // Orange Red
          ),
          textTheme: GoogleFonts.medievalSharpTextTheme(
            ThemeData.dark().textTheme,
          ).copyWith(
            headlineLarge: GoogleFonts.cinzelDecorative(
              fontSize: 48,
              color: const Color(0xFFFFD700),
              shadows: [
                const Shadow(
                  color: Color(0xFF9370DB),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            titleLarge: GoogleFonts.medievalSharp(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF3D5A5A),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: Color(0xFF8B4513),
                width: 2,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Color(0xFFFFD700),
                  width: 2,
                ),
              ),
              textStyle: GoogleFonts.medievalSharp(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        home: const GameWrapper(),
        // Web-specific configurations
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}

class GameWrapper extends StatefulWidget {
  const GameWrapper({super.key});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  bool _isLoading = true;

  void _onLoadingComplete() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _isLoading
          ? LoadingScreen(onLoadingComplete: _onLoadingComplete)
          : const GameScreen(),
    );
  }
}
