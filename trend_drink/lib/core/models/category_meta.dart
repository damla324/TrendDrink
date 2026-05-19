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
    imageUrl: 'Assets/photos/kahve.jpg',
    accentColor: Color(0xFF8B4513),
  ),
  CategoryMeta(
    name: 'Matcha',
    emoji: '🍵',
    imageUrl: 'Assets/photos/matcha.jpg',
    accentColor: Color(0xFF3CA55C),
  ),
  CategoryMeta(
    name: 'Frozen',
    emoji: '🧊',
    imageUrl: 'Assets/photos/frozen.jpg',
    accentColor: Color(0xFF00BCD4),
  ),
  CategoryMeta(
    name: 'Kokteyl',
    emoji: '🍹',
    imageUrl: 'Assets/photos/kokteyl.jpg',
    accentColor: Color(0xFFE91E63),
  ),
  CategoryMeta(
    name: 'Smoothie',
    emoji: '🥤',
    imageUrl: 'Assets/photos/smothe.jpg', // Belirttiğiniz isim: smothe.jpg
    accentColor: Color(0xFF8BC34A),
  ),
  CategoryMeta(
    name: 'Çay',
    emoji: '🫖',
    imageUrl: 'Assets/photos/çay.jpg',
    accentColor: Color(0xFF9C27B0),
  ),
  CategoryMeta(
    name: 'Soda',
    emoji: '🫧',
    imageUrl: 'Assets/photos/soda.jpg',
    accentColor: Color(0xFFFFC107),
  ),
  CategoryMeta(
    name: 'Fit',
    emoji: '💪',
    imageUrl: 'Assets/photos/fit.jpg',
    accentColor: Color(0xFF4CAF50),
  ),
];
