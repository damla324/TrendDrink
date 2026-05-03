import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/data/datasources/drink_local_source.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';

class DrinkRepositoryImpl implements DrinkRepository {
  DrinkRepositoryImpl({required DrinkLocalSource localSource}) : _localSource = localSource;

  final DrinkLocalSource _localSource;

  @override
  Future<List<DrinkModel>> fetchAllDrinks() async {
    try {
      return await _localSource.fetchDrinks();
    } catch (_) {
      return <DrinkModel>[];
    }
  }

  @override
  Future<DrinkModel?> fetchDrinkById(String id) async {
    final all = await fetchAllDrinks();
    try {
      return all.firstWhere((drink) => drink.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DrinkModel>> recommendByIngredients(List<String> ingredients) async {
    final all = await fetchAllDrinks();
    final lower = ingredients.map((element) => element.toLowerCase()).toSet();
    return all
        .where((drink) => drink.ingredients
            .map((ingredient) => ingredient.toLowerCase())
            .any(lower.contains))
        .toList();
  }

  @override
  Future<List<DrinkModel>> searchDrinks(String query) async {
    final all = await fetchAllDrinks();
    final lowerQuery = query.toLowerCase();
    return all
        .where((drink) => drink.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
