import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final drinkNotifierProvider = StateNotifierProvider<DrinkNotifier, AsyncValue<List<DrinkModel>>>(
  (ref) {
    return DrinkNotifier(repository: ref.read(drinkRepositoryProvider));
  },
);

final selectedCategoryProvider = StateProvider<String?>((_) => null);
final assistantQueryProvider = StateProvider<String>((_) => '');
final ingredientInputProvider = StateProvider<String>((_) => '');

class DrinkNotifier extends StateNotifier<AsyncValue<List<DrinkModel>>> {
  DrinkNotifier({required DrinkRepository repository})
      : _repository = repository,
        super(const AsyncValue.loading()) {
    loadDrinks();
  }

  final DrinkRepository _repository;
  List<DrinkModel> _cache = <DrinkModel>[];

  Future<void> loadDrinks() async {
    state = const AsyncValue.loading();
    try {
      _cache = await _repository.fetchAllDrinks();
      state = AsyncValue.data(_cache);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final results = query.isEmpty ? _cache : await _repository.searchDrinks(query);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> filterByCategory(String? category) async {
    state = const AsyncValue.loading();
    try {
      if (category == null || category.isEmpty) {
        state = AsyncValue.data(_cache);
        return;
      }
      final filtered = _cache.where((drink) => drink.category == category).toList();
      state = AsyncValue.data(filtered);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<DrinkModel>> recommendByIngredients(String ingredients) async {
    try {
      if (ingredients.trim().isEmpty) {
        return <DrinkModel>[];
      }
      final items = ingredients
          .split(RegExp(r'[,
;]'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
      return await _repository.recommendByIngredients(items);
    } catch (_) {
      return <DrinkModel>[];
    }
  }
}
