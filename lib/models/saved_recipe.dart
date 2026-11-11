class SavedRecipe {
  final int? id;
  final String recipeName;
  final String? description;
  final String ingredients;
  final String instructions;
  final String? imageUrl;
  final String? cuisine;
  final String difficulty;
  final int prepTime;
  final int cookTime;
  final int servings;
  final DateTime? createdAt;

  const SavedRecipe({
    this.id,
    required this.recipeName,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.cuisine,
    this.difficulty = 'Mudah',
    this.prepTime = 0,
    this.cookTime = 0,
    this.servings = 1,
    this.createdAt,
  });

  factory SavedRecipe.fromJson(Map<String, dynamic> json) {
    return SavedRecipe(
      id: json['id'] as int?,
      recipeName: json['recipe_name'] as String,
      description: json['description'] as String?,
      ingredients: json['ingredients'] as String,
      instructions: json['instructions'] as String,
      imageUrl: json['image_url'] as String?,
      cuisine: json['cuisine'] as String?,
      difficulty: json['difficulty'] as String? ?? 'Mudah',
      prepTime: json['prep_time'] as int? ?? 0,
      cookTime: json['cook_time'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe_name': recipeName,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'image_url': imageUrl,
      'cuisine': cuisine,
      'difficulty': difficulty,
      'prep_time': prepTime,
      'cook_time': cookTime,
      'servings': servings,
    };
  }

  SavedRecipe copyWith({
    int? id,
    String? recipeName,
    String? description,
    String? ingredients,
    String? instructions,
    String? imageUrl,
    String? cuisine,
    String? difficulty,
    int? prepTime,
    int? cookTime,
    int? servings,
    DateTime? createdAt,
  }) {
    return SavedRecipe(
      id: id ?? this.id,
      recipeName: recipeName ?? this.recipeName,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      cuisine: cuisine ?? this.cuisine,
      difficulty: difficulty ?? this.difficulty,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
