class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final String image;
  final double rating;
  final int reviewCount;
  final List<String> mealType;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      difficulty: json['difficulty'] ?? 'Unknown',
      cuisine: json['cuisine'] ?? 'Unknown',
      image: json['image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      mealType: List<String>.from(json['mealType'] ?? []),
    );
  }

  int get totalTime => prepTimeMinutes + cookTimeMinutes;

  String get difficultyLabel {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Mudah';
      case 'medium':
        return 'Sedang';
      case 'hard':
        return 'Sulit';
      default:
        return difficulty;
    }
  }

  String get cuisineLabel => translateCuisine(cuisine);

  List<String> get mealTypeLabels =>
      mealType.map(translateMealType).toList();
}

String translateCuisine(String cuisine) {
  const translations = {
    'american': 'Amerika',
    'asian': 'Asia',
    'brazilian': 'Brasil',
    'chinese': 'Tiongkok',
    'french': 'Prancis',
    'greek': 'Yunani',
    'indian': 'India',
    'italian': 'Italia',
    'japanese': 'Jepang',
    'korean': 'Korea',
    'lebanese': 'Lebanon',
    'mediterranean': 'Mediterania',
    'mexican': 'Meksiko',
    'moroccan': 'Maroko',
    'pakistani': 'Pakistan',
    'russian': 'Rusia',
    'spanish': 'Spanyol',
    'thai': 'Thailand',
    'turkish': 'Turki',
    'vietnamese': 'Vietnam',
  };

  return translations[cuisine.toLowerCase()] ?? cuisine;
}

String translateMealType(String mealType) {
  const translations = {
    'breakfast': 'Sarapan',
    'lunch': 'Makan Siang',
    'dinner': 'Makan Malam',
    'snack': 'Camilan',
    'dessert': 'Hidangan Penutup',
    'appetizer': 'Hidangan Pembuka',
    'beverage': 'Minuman',
    'side dish': 'Lauk Pendamping',
  };

  return translations[mealType.toLowerCase()] ?? mealType;
}