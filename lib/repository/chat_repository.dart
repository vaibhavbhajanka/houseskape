import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_room_model.dart';

abstract class ChatRepository {
  Stream<List<ChatRoom>> roomsStream(String uid);
  Stream<List<Message>> messagesStream(String roomId,
      {int limit = 30, DocumentSnapshot? startAfter});
  Future<String> createOrGetRoom(String uidMe, String uidOther);
  Future<void> send(String roomId, String senderId, String text);
  Future<void> markRead(String roomId, String uidMe);
}

class FirestoreChatRepository implements ChatRepository {
  final FirebaseFirestore firestore;
  FirestoreChatRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ChatRoom>> roomsStream(String uid) {
    // Avoid arrayContains + orderBy composite-index requirement by
    // removing the server-side orderBy and sorting on the client.
    return firestore
        .collection('chatRooms')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      final rooms = snapshot.docs
          .map((doc) => ChatRoom.fromMap(doc.id, doc.data()))
          .toList();
      rooms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return rooms;
    });
  }

  @override
  Stream<List<Message>> messagesStream(String roomId,
      {int limit = 30, DocumentSnapshot? startAfter}) {
    Query query = firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            Message.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  @override
  Future<String> createOrGetRoom(String uidMe, String uidOther) async {
    final rooms = await firestore
        .collection('chatRooms')
        .where('participants', arrayContains: uidMe)
        .get();
    for (final doc in rooms.docs) {
      final data = doc.data();
      final participants = List<String>.from(data['participants'] ?? []);
      if (participants.contains(uidOther) && participants.length == 2) {
        return doc.id;
      }
    }
    final doc = firestore.collection('chatRooms').doc();
    await doc.set({
      'participants': [uidMe, uidOther],
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
    });
    return doc.id;
  }

  @override
  Future<void> send(String roomId, String senderId, String text) async {
    final messageRef = firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .doc();
    final now = Timestamp.now();
    final message = {
      'senderId': senderId,
      'text': text,
      'timestamp': now,
      'status': 'sent',
    };
    await messageRef.set(message);
    // Get current room data to update unreadCount
    final roomDoc = await firestore.collection('chatRooms').doc(roomId).get();
    final data = roomDoc.data() ?? {};
    final Map<String, int> unread =
        Map<String, int>.from(data['unreadCount'] ?? {});
    final List<String> participants =
        List<String>.from(data['participants'] ?? []);
    // Increment unread for all except sender
    for (final uid in participants) {
      if (uid != senderId) {
        unread[uid] = (unread[uid] ?? 0) + 1;
      }
    }
    await firestore.collection('chatRooms').doc(roomId).update({
      'lastMessage': {
        'text': text,
        'senderId': senderId,
        'timestamp': now,
      },
      'updatedAt': now,
      'unreadCount': unread,
    });
  }

  @override
  Future<void> markRead(String roomId, String uidMe) async {
    // For v1, just update all my unread messages to 'read' in this room
    final messages = await firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .where('status', isEqualTo: 'sent')
        .where('senderId', isNotEqualTo: uidMe)
        .get();
    for (final doc in messages.docs) {
      await doc.reference.update({'status': 'read'});
    }
    // Reset unreadCount for this user
    await firestore.collection('chatRooms').doc(roomId).update({
      'unreadCount.$uidMe': 0,
    });
  }
}
