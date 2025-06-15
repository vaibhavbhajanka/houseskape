import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:houseskape/repository/chat_repository.dart';
import 'package:houseskape/providers/chat_providers.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class Chat extends StatelessWidget {
  final String chatRoomId;
  final String otherUserName;
  const Chat(
      {super.key, required this.chatRoomId, required this.otherUserName});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }
    return ChangeNotifierProvider(
      create: (_) => ChatThreadProvider(
        repository: FirestoreChatRepository(),
        roomId: chatRoomId,
      ),
      child:
          _ChatThreadBody(currentUid: user.uid, otherUserName: otherUserName),
    );
  }
}

class _ChatThreadBody extends StatefulWidget {
  final String currentUid;
  final String otherUserName;
  const _ChatThreadBody(
      {required this.currentUid, required this.otherUserName});

  @override
  State<_ChatThreadBody> createState() => _ChatThreadBodyState();
}

class _ChatThreadBodyState extends State<_ChatThreadBody> {
  final TextEditingController _controller = TextEditingController();
  bool _didMarkRead = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatThreadProvider>(context);

    if (!_didMarkRead && !provider.loading && provider.error == null) {
      _didMarkRead = true;
      provider.markRead(widget.currentUid);
    }

    return Scaffold(
      appBar: CustomAppBar(
        widget: const SizedBox.shrink(),
        leading: Icons.arrow_back_ios,
        title: widget.otherUserName,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text('Error: ${provider.error}'))
                    : ListView.builder(
                        reverse: true,
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final msg = provider.messages[index];
                          final sendByMe = msg.senderId == widget.currentUid;
                          return MessageTile(
                            message: msg.text,
                            sendByMe: sendByMe,
                            isRead: msg.status == 'read',
                          );
                        },
                      ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: const Color(0x54FFFFFF),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: 'Message...',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () async {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      await provider.send(widget.currentUid, text);
                      _controller.clear();
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.send, color: Color(0xff25262b)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool isRead;
  const MessageTile(
      {super.key,
      required this.message,
      required this.sendByMe,
      required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: sendByMe ? 0 : 24,
        right: sendByMe ? 24 : 0,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
          gradient: LinearGradient(
            colors: sendByMe
                ? [const Color(0xff007EF4), const Color(0xff007EF4)]
                : [const Color(0xff1b3359), const Color(0xff1b3359)],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
