import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../models/saved_recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/saved_recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/saved_recipe_card.dart';

class ExploreScreen extends StatelessWidget {
  final ValueChanged<int> onApiRecipeTap;
  final ValueChanged<SavedRecipe> onSavedRecipeTap;

  const ExploreScreen({
    super.key,
    required this.onApiRecipeTap,
    required this.onSavedRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final savedProvider = context.watch<SavedRecipeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final apiRecipes = recipeProvider.filteredRecipes;

    final query = recipeProvider.searchQuery.toLowerCase();
    final selectedCuisine = recipeProvider.selectedCuisine;

    // Filter resep buatan sendiri
    final savedRecipes = savedProvider.savedRecipes.where((recipe) {
      final matchesSearch = recipe.recipeName.toLowerCase().contains(query);

      final savedCuisine = recipe.cuisine ?? '';

      final matchesCuisine =
          selectedCuisine == 'All' ||
          translateCuisine(savedCuisine).toLowerCase() ==
              translateCuisine(selectedCuisine).toLowerCase();

      return matchesSearch && matchesCuisine;
    }).toList();

    // Gabungkan kategori dari API dan Supabase
    final allCuisines = {
      ...recipeProvider.cuisines.where((cuisine) => cuisine != 'All'),
      ...savedProvider.savedRecipes
          .map((recipe) => recipe.cuisine)
          .whereType<String>()
          .where((cuisine) => cuisine.isNotEmpty),
    }.toList()..sort();

    final isEmpty = apiRecipes.isEmpty && savedRecipes.isEmpty;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Jelajahi Resep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: recipeProvider.searchRecipes,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Cari nama resep...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter kategori
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  labelStyle: TextStyle(
                    color: selectedCuisine == 'All'
                        ? const Color(0xFF38251C)
                        : colorScheme.onSurface,
                  ),
                  selected: selectedCuisine == 'All',
                  selectedColor: const Color(0xFFFFE0C2),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  onSelected: (_) {
                    recipeProvider.filterByCuisine('All');
                  },
                ),
                ...allCuisines.map((cuisine) {
                  final selected =
                      translateCuisine(selectedCuisine).toLowerCase() ==
                      translateCuisine(cuisine).toLowerCase();

                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(translateCuisine(cuisine)),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF38251C)
                            : colorScheme.onSurface,
                      ),
                      selected: selected,
                      selectedColor: const Color(0xFFFFE0C2),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      onSelected: (_) {
                        recipeProvider.filterByCuisine(cuisine);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Hasil pencarian
          Expanded(
            child: Builder(
              builder: (context) {
                if ((recipeProvider.isLoading || savedProvider.isLoading) &&
                    isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (isEmpty &&
                    (recipeProvider.errorMessage != null ||
                        savedProvider.errorMessage != null)) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gagal memuat resep.',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await Future.wait([
                              recipeProvider.loadRecipes(),
                              savedProvider.loadSavedRecipes(),
                            ]);
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (isEmpty) {
                  return Center(
                    child: Text(
                      'Resep tidak ditemukan.',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    final crossAxisCount = width >= 900
                        ? 4
                        : width >= 600
                        ? 3
                        : 2;

                    final totalRecipes =
                        apiRecipes.length + savedRecipes.length;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: totalRecipes,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: width < 400 ? 0.72 : 0.76,
                      ),
                      itemBuilder: (context, index) {
                        if (index < apiRecipes.length) {
                          final recipe = apiRecipes[index];

                          return RecipeCard(
                            recipe: recipe,
                            onTap: () => onApiRecipeTap(recipe.id),
                          );
                        }

                        final savedIndex = index - apiRecipes.length;
                        final recipe = savedRecipes[savedIndex];

                        return SavedRecipeCard(
                          recipe: recipe,
                          onTap: () => onSavedRecipeTap(recipe),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
