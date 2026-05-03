import 'package:trenddrink/core/models/drink_model.dart';

abstract class DrinkRepository {
  Future<List<DrinkModel>> fetchAllDrinks();
  Future<DrinkModel?> fetchDrinkById(String id);
  Future<List<DrinkModel>> searchDrinks(String query);
  Future<List<DrinkModel>> recommendByIngredients(List<String> ingredients);
}
