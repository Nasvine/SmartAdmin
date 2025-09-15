import 'package:lottie/lottie.dart';
import 'package:smart_admin/src/constants/colors.dart';
import 'package:smart_admin/src/constants/sizes.dart';
import 'package:smart_admin/src/constants/texts.dart';
import 'package:smart_admin/src/repository/chat_service.dart';
import 'package:smart_admin/src/screens/chat/chat_screen.dart';
import 'package:smart_admin/src/utils/helpers/helper_function.dart';
import 'package:smart_admin/src/utils/texts/text_custom.dart';
import 'package:smart_admin/src/utils/texts/text_form_field_simple_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _chatService = ChatService();
  final _authUser = FirebaseAuth.instance.currentUser!;
  final _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            /// Search Field
            SizedBox(
              height: 45,
              child: TextFormFieldSimpleCustom(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value!.toLowerCase();
                  });
                },
                keyboardType: TextInputType.text,
                obscureText: false,
                labelText: 'Rechercher une conversation',
                hintText: 'Entrez un nom ou email',
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: isDark ? ColorApp.tWhiteColor : ColorApp.tBlackColor,
                ),
                labelStyleColor: isDark
                    ? ColorApp.tWhiteColor
                    : ColorApp.tBlackColor,
                hintStyleColor: isDark
                    ? ColorApp.tWhiteColor
                    : ColorApp.tBlackColor,
                borderRadiusBorder: 10,
                borderSideRadiusBorder: isDark
                    ? ColorApp.tsecondaryColor
                    : ColorApp.tSombreColor,
                borderRadiusFocusedBorder: 10,
                borderSideRadiusFocusedBorder: isDark
                    ? ColorApp.tsecondaryColor
                    : ColorApp.tSombreColor,
                cursorColor: isDark
                    ? ColorApp.tWhiteColor
                    : ColorApp.tBlackColor,
              ),
            ),

            /// Chat List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getChatRooms(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            height: 150,
                            width: 150,
                            'assets/images/no_data.json',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          TextCustom(
                            TheText: "Aucune conversation trouvée",
                            TheTextSize: 13,
                          ),
                        ],
                      ),
                    );
                  }
                  final chatDocs = snapshot.data!.docs;
                  return ListView.separated(
                    itemCount: chatDocs.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final chatRoom = chatDocs[index];
                      final users = List<String>.from(chatRoom['users']);
                      final otherUserId = users.firstWhere(
                        (uid) => uid != _authUser.uid,
                        orElse: () => '',
                      );
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(otherUserId)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return const SizedBox();
                          }

                          final user =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          final fullName = user['fullName'] ?? '';
                          final email = user['email'] ?? '';
                          final profile = user['profilePicture'];
                          final lastMessage = chatRoom['lastMessage'] ?? '';
                          final timestamp = chatRoom['createdAt'] as Timestamp;

                          // Filtrage via recherche
                          final query = _searchQuery;
                          if (query.isNotEmpty &&
                              !(fullName.toLowerCase().contains(query) ||
                                  email.toLowerCase().contains(query))) {
                            return const SizedBox();
                          }

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    receiverID: otherUserId,
                                    receiverEmail: email,
                                  ),
                                ),
                              );
                            },
                            leading: profile == "" || profile == null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.jpg",
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(profile),
                                  ),
                            title: TextCustom(
                              TheText: fullName,
                              TheTextSize: THelperFunctions.w(context, 0.04),
                              TheTextFontWeight: FontWeight.bold,
                            ),
                            subtitle: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              _formatTime(timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final time = timestamp.toDate();
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;

    if (isToday) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}
