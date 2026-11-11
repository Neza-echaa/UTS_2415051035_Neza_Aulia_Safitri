import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/recipe_provider.dart';
import 'providers/saved_recipe_provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tlzernavdnkammrqxlqs.supabase.co',
    publishableKey: 'sb_publishable_uZafKYSBT0j3AbLGKNdTVw_LzMubgq9',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()
            ..loadRecipes()
            ..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => SavedRecipeProvider()..loadSavedRecipes(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..loadProfile()),
      ],
      child: const RecipeMateApp(),
    ),
  );
}

class RecipeMateApp extends StatelessWidget {
  const RecipeMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RecipeMate',

      themeMode: settings.themeMode,

      locale: settings.locale,
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8873A),
          brightness: Brightness.light,
          primary: const Color(0xFFE8873A),
          surface: const Color(0xFFFFFBF5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF5),
          foregroundColor: Color(0xFF38251C),
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8873A),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF171717),

        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: const Color(0xFFF1F1F1),
          displayColor: const Color(0xFFF1F1F1),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171717),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(color: Color(0xFF252525), elevation: 0),

        dividerColor: Colors.white24,
      ),

      home: const MainNavigationScreen(),
    );
  }
}
