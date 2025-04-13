import 'package:flutter/foundation.dart';

class Recipe {
  final String name;
  final List<String> ingredients;
  final String result;
  final int points;
  final Duration cookTime;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.result,
    required this.points,
    required this.cookTime,
  });
}

class Cauldron {
  List<String> ingredients = [];
  DateTime? startCookingTime;
  bool isCooking = false;
  bool isBurned = false;

  void addIngredient(String ingredient) {
    ingredients.add(ingredient);
  }

  void startCooking() {
    startCookingTime = DateTime.now();
    isCooking = true;
  }

  void empty() {
    ingredients.clear();
    startCookingTime = null;
    isCooking = false;
    isBurned = false;
  }
}

class GameState extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  int _level = 1;
  int _lives = 3;
  bool _isGameOver = false;
  List<Recipe> _activeRecipes = [];
  List<String> _availableIngredients = [
    'mushroom',
    'herb',
    'crystal',
    'flower',
    'root',
    'berry',
    'leaf',
    'gem',
  ];

  List<Cauldron> _cauldrons = [
    Cauldron(),
    Cauldron(),
    Cauldron(),
  ];

  final List<Recipe> _recipes = [
    Recipe(
      name: 'Health Potion',
      ingredients: ['mushroom', 'herb', 'berry'],
      result: 'health_potion',
      points: 100,
      cookTime: Duration(seconds: 5),
    ),
    Recipe(
      name: 'Mana Potion',
      ingredients: ['crystal', 'flower', 'gem'],
      result: 'mana_potion',
      points: 150,
      cookTime: Duration(seconds: 6),
    ),
    Recipe(
      name: 'Speed Elixir',
      ingredients: ['root', 'leaf', 'berry'],
      result: 'speed_elixir',
      points: 200,
      cookTime: Duration(seconds: 4),
    ),
  ];

  // Getters
  int get score => _score;
  int get highScore => _highScore;
  int get level => _level;
  int get lives => _lives;
  bool get isGameOver => _isGameOver;
  List<Recipe> get activeRecipes => _activeRecipes;
  List<String> get availableIngredients => _availableIngredients;
  List<Cauldron> get cauldrons => _cauldrons;

  GameState() {
    _initializeLevel();
  }

  void _initializeLevel() {
    _activeRecipes = _recipes.take(2 + _level).toList();
    notifyListeners();
  }

  bool checkRecipe(List<String> ingredients) {
    for (final recipe in _activeRecipes) {
      if (recipe.ingredients.length == ingredients.length &&
          recipe.ingredients
              .every((ingredient) => ingredients.contains(ingredient))) {
        return true;
      }
    }
    return false;
  }

  Recipe? getMatchingRecipe(List<String> ingredients) {
    for (final recipe in _activeRecipes) {
      if (recipe.ingredients.length == ingredients.length &&
          recipe.ingredients
              .every((ingredient) => ingredients.contains(ingredient))) {
        return recipe;
      }
    }
    return null;
  }

  void addScore(int points) {
    _score += points;
    if (_score > _highScore) {
      _highScore = _score;
    }
    notifyListeners();
  }

  void loseLife() {
    _lives--;
    if (_lives <= 0) {
      _isGameOver = true;
    }
    notifyListeners();
  }

  void nextLevel() {
    _level++;
    _initializeLevel();
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _lives = 3;
    _level = 1;
    _isGameOver = false;
    for (var cauldron in _cauldrons) {
      cauldron.empty();
    }
    _initializeLevel();
    notifyListeners();
  }

  void addIngredientToCauldron(int cauldronIndex, String ingredient) {
    if (cauldronIndex >= 0 && cauldronIndex < _cauldrons.length) {
      _cauldrons[cauldronIndex].addIngredient(ingredient);
      notifyListeners();
    }
  }

  void startCooking(int cauldronIndex) {
    if (cauldronIndex >= 0 && cauldronIndex < _cauldrons.length) {
      _cauldrons[cauldronIndex].startCooking();
      notifyListeners();
    }
  }

  void emptyCauldron(int cauldronIndex) {
    if (cauldronIndex >= 0 && cauldronIndex < _cauldrons.length) {
      _cauldrons[cauldronIndex].empty();
      notifyListeners();
    }
  }
}
