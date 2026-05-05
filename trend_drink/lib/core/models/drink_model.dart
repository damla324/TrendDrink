import 'package:flutter/material.dart';

class DrinkModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String preparation;
  final List<String> ingredients;
  final String imageUrl;
  final Gradient gradient;
  // ── Rich content fields ───────────────────────────────────────────────
  final String history;
  final String temperature; // 'Sıcak' | 'Soğuk' | 'Her İkisi'
  final List<String> pros;
  final List<String> cons;
  final String tip;

  const DrinkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.preparation,
    required this.ingredients,
    required this.imageUrl,
    required this.gradient,
    this.history = '',
    this.temperature = 'Her İkisi',
    this.pros = const [],
    this.cons = const [],
    this.tip = '',
  });
}
