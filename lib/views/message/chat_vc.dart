import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/baseClass.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:instajobs/controllers/message/message_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../utils/app_styles.dart';

class ChatVc extends StatefulWidget {
  final String chatId;
  final String? bookingId;
  final String? type;
  final String? friendId;

  const ChatVc({super.key, required this.chatId, this.bookingId, this.type, this.friendId});

  @override
  State<ChatVc> createState() => _ChatVcState();
}

class _ChatVcState extends State<ChatVc> {
  final MessageController controller = Get.put(MessageController());
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();



     controller.messageArray.clear();
    if (widget.type == 'booking') {
      controller.getChatListBooking(widget.bookingId ?? '', 'bookingId', widget.friendId ?? '', page: _currentPage, limit: _limit);
    } else if (widget.type == 'offer') {
      controller.getChatListBooking(widget.bookingId ?? '', 'offerId', widget.friendId ?? '', page: _currentPage, limit: _limit);

    } else {
      controller.getChatList(widget.chatId, page: _currentPage, limit: _limit);
    }


    _scrollController.addListener(() async {
      // Since reverse:true, "top" is actually maxScrollExtent
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_isLoadingMore && controller.hasMore.value) {
          _isLoadingMore = true;

          // Save current scroll offset
          final oldScrollOffset = _scrollController.position.pixels;

          _currentPage++;

          if (widget.type == 'booking') {
            await controller.getChatListBooking(widget.bookingId ?? '', 'bookingId', widget.friendId ?? '', page: _currentPage, limit: _limit);
          } else if (widget.type == 'offer') {
            await controller.getChatListBooking(widget.bookingId ?? '', 'offerId', widget.friendId ?? '', page: _currentPage, limit: _limit);

          }else {
            await controller.getChatList(widget.chatId, page: _currentPage, limit: _limit);
          }


          // Wait for new items to render
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Jump back to previous position to avoid jump
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent - oldScrollOffset,
            );
          });

          _isLoadingMore = false;
        }
      }
    });
  }

  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _sendMessage({String? text, File? imageFile}) async {
    if ((text != null && text.trim().isNotEmpty) || imageFile != null) {
      setState(() {
        if (widget.type == 'offer') {
          controller.senMessageFromOffer(widget.bookingId.toString(), widget.friendId ?? '', text!);
        } else if (widget.type == 'booking') {
          controller.senMessageFromBooking(widget.bookingId.toString(), widget.friendId ?? '', text!);
        }else {
          controller.senMessageFromInbox(widget.chatId, widget.friendId ?? '', text!);
        }

      });
      _messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      _sendMessage(imageFile: File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1.0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          "Messages",
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: Obx(() {
              if (controller.messageArray.isEmpty) {
                return const Center(child: Text("No messages yet"));
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,  // newest at bottom
                padding: const EdgeInsets.all(12),
                itemCount: controller.messageArray.length,
                itemBuilder: (context, index) {
                  final msg = controller.messageArray[index];
                  final userId = (StorageService().getUserData().userId ?? 0).toString();
                  final isMe = msg.senderId.toString() == userId;
                  final hasImage = msg.messageType == 1;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: hasImage
                          ? const EdgeInsets.all(4)
                          : const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.black.withOpacity(0.9) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (hasImage)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.network(
                                  msg.message ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (msg.message != null && msg.messageType == 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                msg.message ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            getTimeAgoText(msg.created),
                            style: TextStyle(
                              fontSize: 11,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),


          // Input bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  // TextField + Plus inside same box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ), // <-- extra padding
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ), // <-- text spacing
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.orangeAccent,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orangeAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed:
                          () => _sendMessage(text: _messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      'https://app.superinstajobs.com', // 👈 no port needed
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // 👈 allow upgrade
          .setPath('/socket.io/')                  // 👈 must match server
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    // Connection established


    socket.onConnect((_) {
      print('✅ Connected: id=${socket.id}, transport=${socket.io.engine?.transport?.name}');
    });


    // Listen for messages
    socket.on('message', (data) {
      print('📩 Message received: $data');
    });

    // Error handlers
    socket.onConnectError((data) {
      print('❌ Connect Error: $data');
    });

    socket.onAny((event, data) {
      print('📡 Event: $event, Data: $data');
    });
    socket.onError((data) {
      print('❌ Error: $data');
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected');
    });
  }

  void sendMessage(String message) {
    socket.emit('message', message);
  }

  void disconnect() {
    socket.disconnect();
  }
}

class SocketTest extends StatefulWidget {
  @override
  _SocketTestState createState() => _SocketTestState();
}

class _SocketTestState extends State<SocketTest> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();


    socket = IO.io(
      'https://app.superinstajobs.com', // no :0 port
      IO.OptionBuilder()
          .setTransports(['websocket']) // polling first, websocket upgrade allowed
          .disableAutoConnect()

          .build(),
    );


    socket.onConnect((_) {
      print('✅ Connected');
      socket.emit('msg', 'test from Flutter');
    });

    socket.onDisconnect((_) => print('❌ Disconnected'));
    socket.onConnectError((err) => print('🚨 Connect Error: $err'));
    socket.onError((err) => print('⚠️ Error: $err'));

    socket.on('event', (data) => print('📩 Event: $data'));
    socket.on('fromServer', (data) => print('📡 fromServer: $data'));

    socket.connect(); // 🔑 manually connect
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Check console logs for socket output')),
    );
  }
}

