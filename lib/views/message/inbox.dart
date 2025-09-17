import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/message/message_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/message/chat_vc.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> with BaseClass {
  final MessageController controller = Get.put(MessageController());

  String getTimeAgoText(int? timestamp) {
    if (timestamp == null) return 'Just now';

    final createdDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final diff = DateTime.now().difference(createdDate);

    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getInboxData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.inboxArray.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: controller.inboxArray.length ?? 0,
          padding: const EdgeInsets.all(12),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final chat = controller.inboxArray[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.btncolor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300, // light grey border
                  width: 1, // 1 pixel
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat.profile ?? ''),
                ),
                title: Text(
                  chat.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.btncolor,
                  ),
                ),
                subtitle: Text(
                  chat.message ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                trailing: Text(
                  getTimeAgoText(chat.modified),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                onTap: () {
                  String friendId = '';
                  String outerFriendId = chat.friendId.toString();
                  String type = 'inbox';
                  String chatId = (chat.id).toString();
                  final userId =
                      (StorageService().getUserData().userId ?? 0).toString();
                  if (chat.usersOffers != null) {
                    print(chat.offerId);
                    type = 'offer';
                    chatId = (chat.offerId ?? 0).toString();
                    if (outerFriendId == userId) {
                      if (outerFriendId ==
                          chat.usersOffers?.userId?.toString()) {
                        friendId = chat.userId.toString();
                      } else {
                        friendId = (chat.usersOffers?.userId ?? 0).toString();
                      }
                    } else {
                      friendId = outerFriendId;
                    }
                  } else if (chat.bookingId != 0 ) {
                    type = 'booking';
                    if (outerFriendId == userId) {
                      if (outerFriendId ==
                          chat.bookings?.userId?.toString()) {
                        friendId = chat.userId.toString();
                      } else {
                        friendId = (chat.bookings?.userId ?? 0).toString();
                      }
                    } else {
                      friendId = outerFriendId;
                    }
                    chatId = (chat.bookingId ?? 0).toString();
                  } else  if (chat.jobs != null) {
                    if (outerFriendId == userId) {
                      if (outerFriendId ==
                          chat.jobs?.userId?.toString()) {
                        friendId = chat.userId.toString();
                      } else {
                        friendId = (chat.jobs?.userId ?? 0).toString();
                      }
                    } else {
                      friendId = outerFriendId;
                    }
                  }

                  pushToNextScreen(
                    context: context,
                    destination: ChatVc(
                      chatId: chatId,
                      type: type,
                      friendId: friendId,
                      bookingId: chatId,
                    ),
                  );
                  // open chat screen
                },
              ),
            );
          },
        );
      }),
    );
  }
}
