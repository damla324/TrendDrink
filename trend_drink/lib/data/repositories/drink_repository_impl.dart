import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/data/datasources/drink_local_source.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';

class DrinkRepositoryImpl implements DrinkRepository {
  DrinkRepositoryImpl({required DrinkLocalSource localSource})
      : _localSource = localSource;

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
  Future<List<DrinkModel>> recommendByIngredients(
      List<String> ingredients) async {
    final all = await fetchAllDrinks();
    final normalizedTokens = ingredients
        .map((element) => element.trim().toLowerCase())
        .where((token) => token.isNotEmpty)
        .map(_normalize)
        .toList();

    if (normalizedTokens.isEmpty) return [];

    final results = <MapEntry<DrinkModel, int>>[];

    for (final drink in all) {
      var matchCount = 0;
      var exactCount = 0;

      for (final token in normalizedTokens) {
        for (final ingredient in drink.ingredients) {
          final normalizedIngredient = _normalize(ingredient);
          if (normalizedIngredient == token) {
            matchCount++;
            exactCount += 2;
            break;
          }
          if (normalizedIngredient.contains(token) ||
              token.contains(normalizedIngredient)) {
            matchCount++;
            exactCount += 1;
            break;
          }
        }
      }

      if (matchCount > 0) {
        final score = matchCount * 100 +
            exactCount * 10 -
            (drink.ingredients.length - matchCount);
        results.add(MapEntry(drink, score));
      }
    }

    results.sort((a, b) {
      if (b.value != a.value) return b.value.compareTo(a.value);
      return a.key.title.compareTo(b.key.title);
    });

    return results.map((entry) => entry.key).toList();
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('ğ', 'g')
        .replaceAll('ş', 's')
        .replaceAll('ç', 'c')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u');
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
