import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onRecipeTap;
  final ValueChanged<int> onExploreTap;

  const HomeScreen({
    super.key,
    required this.onRecipeTap,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final recipes = provider.recipes;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.loadRecipes,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Halo, Pecinta Kuliner! 👋',
                style: TextStyle(
                  color: Color(0xFF8B7466),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Mau memasak apa\nhari ini?',
                style: TextStyle(
                  color: Color(0xFF38251C),
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 22),

              TextField(
                onChanged: (value) {
                  provider.searchRecipes(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari resep favoritmu...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Resep Populer',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38251C),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onExploreTap(1);
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Color(0xFFE8873A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (provider.isLoading && recipes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (provider.errorMessage != null &&
                  recipes.isEmpty)
                _errorWidget(provider)
              else if (recipes.isEmpty)
                const Text('Belum ada resep yang tersedia.')
              else
                SizedBox(
                  height: 235,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length > 8
                        ? 8
                        : recipes.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return RecipeCard(
                        recipe: recipe,
                        compact: true,
                        onTap: () => onRecipeTap(recipe.id),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 25),

              const Text(
                'Jelajahi Berdasarkan Jenis Masakan',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38251C),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: provider.cuisines.take(8).map((cuisine) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ActionChip(
                        label: Text(translateCuisine(cuisine)),
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        onPressed: () {
                          provider.filterByCuisine(cuisine);
                          onExploreTap(1);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Rekomendasi untukmu',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38251C),
                ),
              ),

              const SizedBox(height: 12),

              if (recipes.isNotEmpty)
                ...recipes.take(3).map(
                  (recipe) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RecipeCard(
                      recipe: recipe,
                      onTap: () => onRecipeTap(recipe.id),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorWidget(RecipeProvider provider) {
    return Column(
      children: [
        const Text('Gagal memuat resep.'),
        TextButton(
          onPressed: provider.loadRecipes,
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}