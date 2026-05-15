import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/data/datasources/drink_local_source.dart';
import 'package:trenddrink/data/repositories/drink_repository_impl.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';

final drinkLocalSourceProvider = Provider<DrinkLocalSource>((ref) {
  return DrinkLocalSource();
});

final drinkRepositoryProvider = Provider<DrinkRepository>((ref) {
  return DrinkRepositoryImpl(localSource: ref.read(drinkLocalSourceProvider));
});

final drinkNotifierProvider = AsyncNotifierProvider<DrinkNotifier, List<DrinkModel>>(DrinkNotifier.new);

final selectedCategoryProvider = StateProvider<String?>((_) => null);
final assistantQueryProvider = StateProvider<String>((_) => '');
final ingredientInputProvider = StateProvider<String>((_) => '');

class DrinkNotifier extends AsyncNotifier<List<DrinkModel>> {
  DrinkRepository get _repository => ref.read(drinkRepositoryProvider);

  final List<DrinkModel> _cache = <DrinkModel>[];

  @override
  Future<List<DrinkModel>> build() async {
    final drinks = await _repository.fetchAllDrinks();
    _cache
      ..clear()
      ..addAll(drinks);
    return drinks;
  }

  Future<void> search(String query) async {
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return _cache;
      }
      return _repository.searchDrinks(query);
    });
  }

  Future<void> filterByCategory(String? category) async {
    state = await AsyncValue.guard(() async {
      if (category == null || category.isEmpty) {
        return _cache;
      }
      return _cache.where((drink) => drink.category == category).toList();
    });
  }

  Future<void> recommendByIngredientsAndSetState(String ingredients) async {
    state = await AsyncValue.guard(() async {
      if (ingredients.trim().isEmpty) {
        return <DrinkModel>[];
      }
      final items = ingredients
          .split(RegExp(r'[\n,;\s/&+]+'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
      return _repository.recommendByIngredients(items);
    });
  }
}
