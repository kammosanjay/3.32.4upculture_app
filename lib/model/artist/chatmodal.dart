class ChatMessage {
  final String id;
  final String sender;
  final String receiver;
  final String message;
  final String type; // 'text', 'image', 'file', 'audio'
  final String? filePath;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.type,
    this.filePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'type': type,
      'filePath': filePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      type: map['type'],
      filePath: map['filePath'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
