import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/recipe_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()..loadRecipes(),
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
          centerTitle: false,
        ),
      ),
      home: const RecipeMateHome(),
    );
  }
}

class RecipeMateHome extends StatelessWidget {
  const RecipeMateHome({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RecipeMate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: _buildContent(provider),
      ),
    );
  }

  Widget _buildContent(RecipeProvider provider) {
    if (provider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (provider.errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 12),
          const Text('Gagal memuat resep'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: provider.loadRecipes,
            child: const Text('Coba Lagi'),
          ),
        ],
      );
    }

    if (provider.recipes.isEmpty) {
      return const Text('Belum ada resep tersedia.');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.restaurant_menu,
          size: 55,
          color: Color(0xFFE8873A),
        ),
        const SizedBox(height: 12),
        const Text(
          'Resep berhasil dimuat!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${provider.recipes.length} resep ditemukan dari API.',
        ),
      ],
    );
  }
}