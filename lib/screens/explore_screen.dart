import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

class ExploreScreen extends StatelessWidget {
  final ValueChanged<int> onRecipeTap;

  const ExploreScreen({
    super.key,
    required this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Recipes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: provider.searchRecipes,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: provider.cuisines.map((cuisine) {
                final selected = provider.selectedCuisine == cuisine;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cuisine),
                    selected: selected,
                    selectedColor: const Color(0xFFFFE0C2),
                    onSelected: (_) {
                      provider.filterByCuisine(cuisine);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: _buildRecipeContent(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeContent(
    BuildContext context,
    RecipeProvider provider,
  ) {
    if (provider.isLoading && provider.recipes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Gagal memuat resep.'),
            ElevatedButton(
              onPressed: provider.loadRecipes,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final recipes = provider.filteredRecipes;

    if (recipes.isEmpty) {
      return const Center(
        child: Text('Resep tidak ditemukan.'),
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

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: width < 400 ? 0.78 : 0.82,
          ),
          itemBuilder: (context, index) {
            final recipe = recipes[index];

            return RecipeCard(
              recipe: recipe,
              onTap: () => onRecipeTap(recipe.id),
            );
          },
        );
      },
    );
  }
}