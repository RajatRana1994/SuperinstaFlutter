import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import '../../models/feed_tab_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:instajobs/dialogs/ask_dialog.dart';
import 'inline_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instajobs/views/feed_tab/report_vc.dart';
import '../vendor_details/vendor_details_page.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

class FeedDetailVc extends StatefulWidget {
  final String feedId;
  const FeedDetailVc({super.key, required this.feedId});

  @override
  State<FeedDetailVc> createState() => _FeedDetailVcState();
}

class _FeedDetailVcState extends State<FeedDetailVc> with BaseClass {
  FeedTabController feedTabController = Get.put(FeedTabController());
  final Map<int, int> _carouselCurrent = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedTabController.getFeedDetail(widget.feedId);
    feedTabController.getAppSetting();
  }

  String getTimeAgoText(int? timestamp) {
    if (timestamp == null) return 'Posted recently';

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
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final feedItem = feedTabController.feedDetail.value;

      if (feedItem == null) {
        return const Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final List<FeedTabModelDataDataFeedImages> feedImages =
          feedItem?.feedImages
              ?.whereType<FeedTabModelDataDataFeedImages>()
              .toList() ??
          [];

      FeedTabModelDataDataFeedImages? videoItem;
      try {
        videoItem = feedImages.firstWhere(
          (img) =>
              img.video != null &&
              img.video!.isNotEmpty &&
              img.video!.endsWith('.mp4'),
        );
      } catch (_) {
        videoItem = null;
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
            'Feed Details',
            style: AppStyles.fontInkika().copyWith(fontSize: 24),
          ),
          actions: [
            if (StorageService().getUserData().userId != feedItem.userId?.toString()) ... [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.orange, size: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == "About account") {
                    pushToNextScreen(
                      context: context,
                      destination: VendorDetailsPage(
                        feedItem.userId.toString(),
                      ),
                    );
                    // Handle Edit
                  } else if (value == "Report") {
                    Get.bottomSheet(
                      ReportVc(feedId: widget.feedId),
                      isScrollControlled:
                      true, // optional, useful for keyboard/form inputs
                    );

                    // Handle Report
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "About account",
                    child: ListTile(

                      title: Text("About account"),
                    ),
                  ),
                  const PopupMenuItem(
                    value: "Report",
                    child: ListTile(

                      title: Text("Report"),
                    ),
                  ),
                ],
              ),
            ]

          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 2,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            feedTabController
                                    .feedDetail
                                    .value
                                    ?.users
                                    ?.profile ??
                                '',
                          ),
                        ),
                      ),
                      title: Text(
                        feedTabController.feedDetail.value?.users?.name ?? '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Text(
                        feedTabController.feedDetail.value?.description ?? '',
                      ),
                    ),

                    /// Inline Video Player
                    if (videoItem != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: InlineVideoPlayer(videoUrl: videoItem.video!),
                      )
                    else
                      Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount:
                                feedImages.isNotEmpty ? feedImages.length : 1,
                            itemBuilder: (context, imgIndex, realIdx) {
                              if (feedImages.isEmpty) {
                                // Show a placeholder image when feedImages is empty
                                return Container(
                                  color: Colors.grey[300],
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white70,
                                      size: 40,
                                    ),
                                  ),
                                );
                              }

                              final imageUrl = feedImages[imgIndex].images;
                              if (imageUrl == null || imageUrl.isEmpty) {
                                return Container(
                                  color: Colors.grey[300],
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white70,
                                      size: 40,
                                    ),
                                  ),
                                );
                              }

                              return Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.green,
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            options: CarouselOptions(
                              height: 250,
                              viewportFraction: 1.0,
                              onPageChanged: (pos, reason) {
                                setState(() {
                                  //   _carouselCurrent[index] = pos;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                feedImages.asMap().entries.map((entry) {
                                  final currentIndex = _carouselCurrent[0] ?? 0;
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          currentIndex == entry.key
                                              ? AppColors.primaryColor
                                              : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  var feedId = feedItem.id ?? 0;
                                  feedTabController.saveFeedData(
                                    feedId.toString(),
                                    0,
                                    type: 4,
                                  );
                                },
                                icon: Icon(
                                  (feedItem.isLike == 0)
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                ),
                                color: Colors.black,
                              ),
                              Text(feedItem.totalLikes.toString() ?? '0'),
                            ],
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mode_comment_outlined),
                                color: Colors.black,
                              ),
                              Text(feedItem.totalComments.toString() ?? '0'),
                            ],
                          ),
                          Spacer(),

                          Row(
                            children: [
                              SizedBox(width: 5),
                              Text('Tips '),
                              Text(feedItem.totalCoins ?? '0'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Comments Section
              if (feedItem.feedComments != null &&
                  feedItem.feedComments!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        itemCount: feedItem.feedComments?.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final comment = feedItem.feedComments?[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Image
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    comment?.user?.profile ?? '',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Name + Comment
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comment?.user?.name ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            getTimeAgoText(comment?.created),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),
                                      Text(
                                        comment?.comment ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),

                                      const Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // 👈 moves up with keyboard
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border(
                //   top: BorderSide(color: Colors.grey.shade300),
                // ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller:
                          feedTabController
                              .commentController, // 👈 add controller in controller
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.primaryColor),
                    onPressed: () {
                      var feedId = feedItem.id ?? 0;
                      var commentText =
                          feedTabController.commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        feedTabController.sendFeedComment(
                          widget.feedId,
                          commentText,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
