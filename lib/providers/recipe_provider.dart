import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository;

  RecipeProvider({RecipeRepository? repository})
    : _repository = repository ?? RecipeRepository();

  List<Recipe> _recipes = [];
  final Set<int> _favoriteIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedCuisine = 'All';

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes {
    return _recipes
        .where((recipe) => _favoriteIds.contains(recipe.id))
        .toList();
  }

  bool isFavorite(int recipeId) {
    return _favoriteIds.contains(recipeId);
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  String get selectedCuisine => _selectedCuisine;

  List<String> get cuisines {
    final values = _recipes.map((recipe) => recipe.cuisine).toSet().toList();

    values.sort();

    return ['All', ...values];
  }

  List<Recipe> get filteredRecipes {
    return _recipes.where((recipe) {
      final matchesSearch = recipe.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesCuisine =
          _selectedCuisine == 'All' || recipe.cuisine == _selectedCuisine;

      return matchesSearch && matchesCuisine;
    }).toList();
  }

  Future<void> loadRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _repository.getRecipes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Recipe?> loadRecipeDetail(int id) async {
    try {
      return await _repository.getRecipeDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void searchRecipes(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCuisine = 'All';
    notifyListeners();
  }

  void toggleFavorite(int recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }

    notifyListeners();
  }
}
