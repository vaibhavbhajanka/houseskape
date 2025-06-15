import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:houseskape/repository/chat_repository.dart';
import 'package:houseskape/providers/chat_providers.dart';
import 'package:houseskape/model/chat_room_model.dart';
import 'package:houseskape/chat.dart';
import 'package:houseskape/chat_search.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }
    return ChangeNotifierProvider(
      create: (_) => ChatRoomsProvider(
        repository: FirestoreChatRepository(),
        uid: user.uid,
      ),
      child: const _ChatScreenBody(),
    );
  }
}

class _ChatScreenBody extends StatelessWidget {
  const _ChatScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatRoomsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        leading: null,
        title: 'Message',
        widget: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ChatSearch()));
          },
          child: const Icon(
            Icons.search,
            color: Color(0xff25262b),
          ),
        ),
        elevation: 0,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.rooms.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No chats yet',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start a conversation with a property owner',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.rooms.length,
                      itemBuilder: (context, index) {
                        final room = provider.rooms[index];
                        final currentUid =
                            FirebaseAuth.instance.currentUser!.uid;
                        final otherUid = room.participants.firstWhere(
                          (k) => k != currentUid,
                          orElse: () => '',
                        );
                        return ChatRoomsTile(
                          room: room,
                          otherUid: otherUid,
                        );
                      },
                    ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final ChatRoom room;
  final String otherUid;
  const ChatRoomsTile({super.key, required this.room, required this.otherUid});

  @override
  Widget build(BuildContext context) {
    final lastMsg = room.lastMessage;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(otherUid).get(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final name = data?['name'] ?? otherUid;
        final profileUrl = data?['profileImage'] as String?;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      Chat(chatRoomId: room.id, otherUserName: name)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xffcccccc),
                      backgroundImage:
                          profileUrl != null && profileUrl.isNotEmpty
                              ? NetworkImage(profileUrl)
                              : null,
                      child: profileUrl == null || profileUrl.isEmpty
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Color(0xff25262b),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xff25262b),
                                  ),
                                ),
                              ),
                              if (lastMsg != null)
                                Text(
                                  _relativeTime(lastMsg.timestamp.toDate()),
                                  style: const TextStyle(
                                      fontSize: 13, color: Color(0xffb0b0b0)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  lastMsg != null
                                      ? lastMsg.text
                                      : 'No messages yet',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff636363)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xffe7e7e7)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.month}/${dt.day}';
  }
}
