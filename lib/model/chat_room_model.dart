import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> participants; // [uid1, uid2]
  final LastMessage? lastMessage;
  final Timestamp updatedAt;
  final Map<String, int>? unreadCount; // { uid1: 0, uid2: 2 }

  ChatRoom({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
    this.unreadCount,
  });

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoom(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] != null
          ? LastMessage.fromMap(map['lastMessage'])
          : null,
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
      unreadCount: map['unreadCount'] != null
          ? Map<String, int>.from(map['unreadCount'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage?.toMap(),
      'updatedAt': updatedAt,
      if (unreadCount != null) 'unreadCount': unreadCount,
    };
  }
}

class LastMessage {
  final String text;
  final String senderId;
  final Timestamp timestamp;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final String status; // 'sent' | 'read'

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.status,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      status: map['status'] ?? 'sent',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
