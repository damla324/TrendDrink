import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';

class GetDrinkCollectionUseCase {
  GetDrinkCollectionUseCase({required DrinkRepository repository}) : _repository = repository;

  final DrinkRepository _repository;

  Future<List<DrinkModel>> execute() async {
    return _repository.fetchAllDrinks();
  }
}
