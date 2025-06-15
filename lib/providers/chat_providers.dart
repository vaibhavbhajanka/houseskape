import 'package:flutter/material.dart';
import '../repository/chat_repository.dart';
import '../model/chat_room_model.dart';

class ChatRoomsProvider extends ChangeNotifier {
  final ChatRepository repository;
  final String uid;
  List<ChatRoom> _rooms = [];
  bool _loading = true;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  bool get loading => _loading;
  String? get error => _error;

  ChatRoomsProvider({required this.repository, required this.uid}) {
    _listen();
  }

  void _listen() {
    repository.roomsStream(uid).listen((rooms) {
      _rooms = rooms;
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    });
  }
}

class ChatThreadProvider extends ChangeNotifier {
  final ChatRepository repository;
  final String roomId;
  List<Message> _messages = [];
  bool _loading = true;
  String? _error;

  List<Message> get messages => _messages;
  bool get loading => _loading;
  String? get error => _error;

  ChatThreadProvider({required this.repository, required this.roomId}) {
    _listen();
  }

  void _listen() {
    repository.messagesStream(roomId).listen((msgs) {
      _messages = msgs;
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> send(String senderId, String text) async {
    await repository.send(roomId, senderId, text);
  }

  Future<void> markRead(String uidMe) async {
    await repository.markRead(roomId, uidMe);
  }
}
