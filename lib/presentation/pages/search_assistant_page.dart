import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';
import 'package:trenddrink/presentation/widgets/drink_card.dart';

class SearchAssistantPage extends ConsumerStatefulWidget {
  const SearchAssistantPage({super.key});

  @override
  ConsumerState<SearchAssistantPage> createState() => _SearchAssistantPageState();
}

class _SearchAssistantPageState extends ConsumerState<SearchAssistantPage> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    ref.read(assistantQueryProvider.notifier).state = query;
    await ref.read(drinkNotifierProvider.notifier).search(query);
  }

  Future<void> _recommend() async {
    final ingredients = _queryController.text;
    await ref.read(drinkNotifierProvider.notifier).recommendByIngredientsAndSetState(ingredients);
  }

  @override
  Widget build(BuildContext context) {
    final drinkState = ref.watch(drinkNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Asistanı'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _queryController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Ne öğrenmek istiyorsun? Örn: Caramel Cold Brew',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _search,
                      icon: const Icon(Icons.search_outlined),
                      label: const Text('Yazılı ara'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _recommend,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Malzemeden öneri'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: drinkState.when(
                data: (drinks) {
                  if (drinks.isEmpty) {
                    return Center(
                      child: Text(
                        'Elinizdeki malzemelere göre öneri almak için yukarıya yazın.',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      final drink = drinks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: DrinkCard(
                          drink: drink,
                          onTap: () => context.push('/drink/${drink.id}'),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Arama sırasında bir hata oluştu.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
