enum MessageType { text, image, pdf, video, audio }

class ChatMessageTest {
  final String sender; // "User" or "Bot"
  final String text;
  final MessageType type;
  final String? filePath;
  final String timestamp;

  ChatMessageTest({
    required this.sender,
    required this.text,
    this.type = MessageType.text,
    this.filePath,
    required this.timestamp,
  });

  // Convert ChatMessage to Map
  Map<String, dynamic> toMap() {
  return {
    'sender': sender,
    'text': text,
    'type': type.index,
    'filePath': filePath,
    'timestamp': timestamp, // ✅ Include this
  };
}

  // Convert Map to ChatMessage
  // factory ChatMessageTest.fromMap(Map<String, dynamic> map) {
  //   return ChatMessageTest(
  //     sender: map['sender'],
  //     text: map['text'],
  //     timestamp: DateTime.parse(map['timestamp']).toIso8601String(),
  //     type: MessageType.values[map['type']],
  //     filePath: map['filePath'],
  //   );
  // }
  factory ChatMessageTest.fromMap(Map<String, dynamic> map) {
    return ChatMessageTest(
      sender: map['sender'] ?? 'Unknown',
      text: map['text'] ?? '',
      type: MessageType.values[map['type'] ?? 0],
      filePath: map['filePath'], // can be null
      timestamp: map['timestamp'] ??
          DateTime.now().toIso8601String(), // ✅ fallback if null
    );
  }
}
