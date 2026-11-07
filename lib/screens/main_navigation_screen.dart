import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'recipe_detail_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _openRecipe(int id) async {
    final provider = context.read<RecipeProvider>();

    Recipe? recipe;
    for (final item in provider.recipes) {
      if (item.id == id) {
        recipe = item;
        break;
      }
    }

    recipe ??= await provider.loadRecipeDetail(id);

    if (!mounted) return;

    if (recipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka detail resep.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(recipe: recipe!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onRecipeTap: _openRecipe,
        onExploreTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      ExploreScreen(onRecipeTap: _openRecipe),
      const _PlaceholderScreen(
        title: 'My Favorites',
        icon: Icons.favorite_border,
        message: 'Resep favoritmu akan muncul di sini.',
      ),
      const _PlaceholderScreen(
        title: 'Profile',
        icon: Icons.person_outline,
        message: 'Profil pengguna RecipeMate.',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        indicatorColor: const Color(0xFFFFE0C2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 65, color: const Color(0xFFE8873A)),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}