import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/models/auth/user_model.dart';
import 'package:smart_admin/src/repository/chat_service.dart';
import 'package:smart_admin/src/screens/chat/chat_bubble.dart';
import 'package:smart_admin/src/screens/chat/message_bubble.dart';
import 'package:smart_admin/src/screens/tabs.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_custom/text_custom.dart';

class ChatScreen extends StatefulWidget {
  final String receiverID;
  final String receiverEmail;

  ChatScreen({
    super.key,
    required this.receiverID,
    required this.receiverEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _chatSarvice = ChatService();

  final _auth = FirebaseAuth.instance.currentUser!;
  UserModel receiverInfo = UserModel.empty();

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // car reverse: true
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatSarvice.sendMessage(
        widget.receiverID,
        _messageController.text,
        receiverInfo.fcmToken!,
      );
      FocusScope.of(context).unfocus();
      _messageController.clear();
    }
    _scrollToBottom();
  }

  void fetchReceiver() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverID)
        .get();
    if (data.exists && data.data()!.isNotEmpty) {
      final user = UserModel.fromSnapshot(data);

      setState(() {
        receiverInfo = user;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReceiver();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.offAll(() => TabsScreen(initialIndex: 2)),
          icon: Icon(
            Icons.arrow_back,
            color: THelperFunctions.isDarkMode(context)
                ? ColorApp.tWhiteColor
                : ColorApp.tBlackColor,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            receiverInfo.profilePicture == ""
                ? CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  )
                : CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(receiverInfo.profilePicture!),
                  ),
            SizedBox(width: 10),
            TextCustom(
              TheText: receiverInfo.fullName,
              TheTextSize: 14,
              TheTextFontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(context),
        ],
      ),
    );
  }

  // message list
  Widget _buildMessageList() {
    String senderID = _auth.uid;
    return StreamBuilder(
      stream: _chatSarvice.getMessages(widget.receiverID, senderID),

      /*  builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //error
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        return ListView(
          reverse: true,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        ); 
        
        */
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No Messages found.'));
        }

        if (chatSnapshots.hasError) {
          return const Center(child: Text('Something went wrong ...'));
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          controller: _scrollController,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage =
                loadedMessages[index].data() as Map<String, dynamic>;

            if (!chatMessage.containsKey('message') ||
                !chatMessage.containsKey('senderID')) {
              return SizedBox.shrink();
            }
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data() as Map<String, dynamic>
                : null;

            final currentMessageUserId = chatMessage['senderID'];
            final nextMessageUserId = nextChatMessage != null
                ? nextChatMessage['receiverID']
                : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['message'],
                isMe: _auth.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: '',
                username: _auth.uid == chatMessage['senderID']
                    ? 'Vous'
                    : widget.receiverEmail,

                message: chatMessage['message'],
                isMe: _auth.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }

  // build message input
  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormFieldSimpleCustom(
              keyboardType: TextInputType.text,
              obscureText: false,
              borderRadiusBorder: 10,
              cursorColor: THelperFunctions.isDarkMode(context)
                  ? ColorApp.tWhiteColor
                  : ColorApp.tBlackColor,
              borderSideRadiusBorder: THelperFunctions.isDarkMode(context)
                  ? ColorApp.tsecondaryColor
                  : ColorApp.tSombreColor,
              borderRadiusFocusedBorder: 10,
              borderSideRadiusFocusedBorder:
                  THelperFunctions.isDarkMode(context)
                  ? ColorApp.tsecondaryColor
                  : ColorApp.tSombreColor,
              controller: _messageController,
              hintText: 'envoyer un message ...',
              labelStyleColor: THelperFunctions.isDarkMode(context)
                  ? ColorApp.tWhiteColor
                  : ColorApp.tBlackColor,
              hintStyleColor: THelperFunctions.isDarkMode(context)
                  ? ColorApp.tWhiteColor
                  : ColorApp.tBlackColor,
              validator: null,
            ),
            /* child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: "Send a message ..."),
              controller: _messageController,
            ), */
          ),

          Container(
            decoration: const BoxDecoration(
              color: ColorApp.tsecondaryColor,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 20, left: 20),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: ColorApp.tWhiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
