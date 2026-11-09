import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/recipe_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'providers/saved_recipe_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL'),
  publishableKey: const String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  ),
);
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RecipeProvider()..loadRecipes(),
      ),
      ChangeNotifierProvider(
        create: (_) => SavedRecipeProvider()..loadSavedRecipes(),
      ),
    ],
    child: const RecipeMateApp(),
  ),
);
}

class RecipeMateApp extends StatelessWidget {
  const RecipeMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RecipeMate',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8873A),
          primary: const Color(0xFFE8873A),
          surface: const Color(0xFFFFFBF5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF5),
          foregroundColor: Color(0xFF38251C),
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}