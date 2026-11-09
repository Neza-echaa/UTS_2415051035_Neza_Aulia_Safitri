
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../models/saved_recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/saved_recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/saved_recipe_card.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onApiRecipeTap;
  final ValueChanged<SavedRecipe> onSavedRecipeTap;
  final ValueChanged<int> onExploreTap;

  const HomeScreen({
    super.key,
    required this.onApiRecipeTap,
    required this.onSavedRecipeTap,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final savedProvider = context.watch<SavedRecipeProvider>();

    final apiRecipes = recipeProvider.filteredRecipes;

    final query = recipeProvider.searchQuery.toLowerCase();
    final selectedCuisine = recipeProvider.selectedCuisine;

    final savedRecipes = savedProvider.savedRecipes.where((recipe) {
      final matchesSearch =
          recipe.recipeName.toLowerCase().contains(query);

      final cuisine = recipe.cuisine ?? '';

      final matchesCuisine = selectedCuisine == 'All' ||
          translateCuisine(cuisine).toLowerCase() ==
              translateCuisine(selectedCuisine).toLowerCase();

      return matchesSearch && matchesCuisine;
    }).toList();

    final allCuisines = {
      ...apiRecipes.map((recipe) => recipe.cuisine),
      ...savedRecipes
          .map((recipe) => recipe.cuisine)
          .whereType<String>()
          .where((cuisine) => cuisine.isNotEmpty),
    }.toList()
      ..sort();

    final allRecipesEmpty =
        apiRecipes.isEmpty && savedRecipes.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              recipeProvider.loadRecipes(),
              savedProvider.loadSavedRecipes(),
            ]);
          },
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

              // Pencarian
              TextField(
                onChanged: recipeProvider.searchRecipes,
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

              // Resep Populer
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
                    onPressed: () => onExploreTap(1),
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

              if ((recipeProvider.isLoading ||
                      savedProvider.isLoading) &&
                  allRecipesEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (allRecipesEmpty &&
                  (recipeProvider.errorMessage != null ||
                      savedProvider.errorMessage != null))
                const Text('Gagal memuat resep.')
              else if (allRecipesEmpty)
                const Text('Belum ada resep yang tersedia.')
              else
                SizedBox(
                  height: 235,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...apiRecipes.take(8).map(
                        (recipe) => Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: RecipeCard(
                            recipe: recipe,
                            compact: true,
                            onTap: () =>
                                onApiRecipeTap(recipe.id),
                          ),
                        ),
                      ),
                      ...savedRecipes.take(8).map(
                        (recipe) => Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: SavedRecipeCard(
                            recipe: recipe,
                            compact: true,
                            onTap: () =>
                                onSavedRecipeTap(recipe),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 25),

              // Kategori masakan
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
                  children: [
                    ...allCuisines.map((cuisine) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: ActionChip(
                          label: Text(
                            translateCuisine(cuisine),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                          onPressed: () {
                            recipeProvider.filterByCuisine(
                              cuisine,
                            );
                            onExploreTap(1);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Rekomendasi
              const Text(
                'Rekomendasi untukmu',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38251C),
                ),
              ),

              const SizedBox(height: 12),

              ...apiRecipes.take(3).map(
                (recipe) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () => onApiRecipeTap(recipe.id),
                  ),
                ),
              ),

              ...savedRecipes.take(3).map(
                (recipe) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SavedRecipeCard(
                    recipe: recipe,
                    onTap: () => onSavedRecipeTap(recipe),
                  ),
                ),
              ),

              if (!allRecipesEmpty &&
                  apiRecipes.isEmpty &&
                  savedRecipes.isEmpty)
                const Text('Belum ada rekomendasi resep.'),
            ],
          ),
        ),
      ),
    );
  }
}
