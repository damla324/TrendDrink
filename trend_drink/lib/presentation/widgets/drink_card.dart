import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trenddrink/core/models/drink_model.dart';

class DrinkCard extends StatelessWidget {
  const DrinkCard({super.key, required this.drink, required this.onTap});

  final DrinkModel drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Positioned.fill(
              child: drink.imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: drink.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.black12),
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.black26),
                    )
                  : Image.asset(
                      drink.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          Container(color: Colors.black26),
                    ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.42),
                      Colors.transparent,
                      Colors.black.withOpacity(0.52),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      drink.gradient.colors.first.withOpacity(0.28),
                      drink.gradient.colors.last.withOpacity(0.18)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Chip(
                      backgroundColor: Colors.white24,
                      label: Text(
                        drink.category.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, letterSpacing: 0.6),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      drink.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      drink.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: drink.ingredients
                          .take(3)
                          .map(
                            (name) => Chip(
                              backgroundColor: Colors.white24,
                              label: Text(name,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
