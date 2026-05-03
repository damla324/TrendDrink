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

  DrinkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.preparation,
    required this.ingredients,
    required this.imageUrl,
    required this.gradient,
  });

  factory DrinkModel.fromJson(Map<String, dynamic> json) {
    final ingredientData = json['ingredients'] as List<dynamic>;
    return DrinkModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      preparation: json['preparation'] as String,
      ingredients: ingredientData.cast<String>().toList(),
      imageUrl: json['imageUrl'] as String,
      gradient: LinearGradient(
        colors: (json['gradient'] as List<dynamic>)
            .map((color) => Color(color as int))
            .cast<Color>()
            .toList(),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'preparation': preparation,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'gradient': gradient.colors.map((color) => color.toARGB32()).toList(),
    };
  }
}
