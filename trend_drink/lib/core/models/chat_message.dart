enum ChatAuthor { user, assistant }

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    this.drinkId,
  });

  final String id;
  final String text;
  final ChatAuthor author;
  final String? drinkId;
}
