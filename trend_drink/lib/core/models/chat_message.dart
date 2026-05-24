import 'dart:typed_data';

enum ChatAuthor { user, assistant }

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    this.drinkId,
    this.imageBytes,
    this.imageName,
  });

  final String id;
  final String text;
  final ChatAuthor author;
  final String? drinkId;

  /// Multimodal: kullanıcının chat'e eklediği görsel (örn. malzeme fotoğrafı).
  final Uint8List? imageBytes;
  final String? imageName;
}
