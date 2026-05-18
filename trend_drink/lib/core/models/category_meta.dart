import 'package:flutter/material.dart';

class CategoryMeta {
  const CategoryMeta({
    required this.name,
    required this.emoji,
    required this.imageUrl,
    required this.accentColor,
  });
  final String name;
  final String emoji;
  final String imageUrl;
  final Color accentColor;
}

const List<CategoryMeta> kCategories = [
  CategoryMeta(
    name: 'Kahve',
    emoji: '☕',
    imageUrl: 'Assets/photo/kahve_category_main.jpg',
    accentColor: Color(0xFF8B4513),
  ),
  CategoryMeta(
    name: 'Matcha',
    emoji: '🍵',
    imageUrl:
        'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF3CA55C),
  ),
  CategoryMeta(
    name: 'Frozen',
    emoji: '🧊',
    imageUrl:
        'https://images.unsplash.com/photo-1572490122747-3968b75cc699?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF00BCD4),
  ),
  CategoryMeta(
    name: 'Kokteyl',
    emoji: '🍹',
    imageUrl:
        'https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFFE91E63),
  ),
  CategoryMeta(
    name: 'Smoothie',
    emoji: '🥤',
    imageUrl:
        'https://images.unsplash.com/photo-1543255006-d6395b6f1171?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF8BC34A),
  ),
  CategoryMeta(
    name: 'Çay',
    emoji: '🫖',
    imageUrl:
        'https://images.unsplash.com/photo-1576092762740-410023a10526?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF9C27B0),
  ),
  CategoryMeta(
    name: 'Soda',
    emoji: '🫧',
    imageUrl:
        'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFFFFC107),
  ),
  CategoryMeta(
    name: 'Fit',
    emoji: '💪',
    imageUrl:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=400&auto=format&fit=crop',
    accentColor: Color(0xFF4CAF50),
  ),
];
