
import 'package:flutter/material.dart';

import '../models/saved_recipe.dart';
import '../repositories/saved_recipe_repository.dart';

class SavedRecipeProvider extends ChangeNotifier {
  final SavedRecipeRepository _repository;

  SavedRecipeProvider({
    SavedRecipeRepository? repository,
  }) : _repository = repository ?? SavedRecipeRepository();

  List<SavedRecipe> _savedRecipes = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<SavedRecipe> get savedRecipes => _savedRecipes;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadSavedRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedRecipes = await _repository.getSavedRecipes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRecipe(SavedRecipe recipe) async {
    try {
      _errorMessage = null;

      final newRecipe = await _repository.createRecipe(recipe);

      _savedRecipes.insert(0, newRecipe);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRecipe(
    int id,
    SavedRecipe recipe,
  ) async {
    try {
      _errorMessage = null;

      final updatedRecipe = await _repository.editRecipe(
        id,
        recipe,
      );

      final index = _savedRecipes.indexWhere(
        (item) => item.id == id,
      );

      if (index != -1) {
        _savedRecipes[index] = updatedRecipe;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRecipe(int id) async {
    try {
      _errorMessage = null;

      await _repository.removeRecipe(id);

      _savedRecipes.removeWhere(
        (recipe) => recipe.id == id,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
