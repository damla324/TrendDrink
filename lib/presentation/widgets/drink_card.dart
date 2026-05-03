import 'package:flutter/material.dart';
import 'package:trenddrink/core/models/drink_model.dart';

class DrinkCard extends StatelessWidget {
  const DrinkCard({super.key, required this.drink, required this.onTap});

  final DrinkModel drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: drink.gradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  drink.category,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  drink.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  drink.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color.fromRGBO(255, 255, 255, 0.88),
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    ...drink.ingredients.take(3).map((name) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            backgroundColor: Colors.white24,
                            label: Text(
                              name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                    const Spacer(),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
