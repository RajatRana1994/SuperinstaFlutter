import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:get/get.dart';

import '../../models/feed_tab_model.dart';
import '../../utils/app_colors.dart';
import 'inline_video_player.dart';

class FeedTabPage extends StatefulWidget {
  const FeedTabPage({super.key});

  @override
  State<FeedTabPage> createState() => _FeedTabPageState();
}

class _FeedTabPageState extends State<FeedTabPage> {
  FeedTabController feedTabController = Get.put(FeedTabController());
  final Map<int, int> _carouselCurrent = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedTabController.getFeedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: GetBuilder<FeedTabController>(
        init: feedTabController,
        builder: (snapshot) {
          final feedList = feedTabController.feedList;

          if (feedList == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: feedList.length,
            itemBuilder: (context, index) {
              final feedItem = feedList[index];
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

              return Card(
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
                            feedItem?.users?.profile ?? '',
                          ),
                        ),
                      ),
                      title: Text(feedItem?.users?.name ?? ''),

                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert),
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Text(feedItem?.description ?? ''),
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
                            itemCount: feedImages.length,
                            itemBuilder: (context, imgIndex, realIdx) {
                              return Image.network(
                                feedImages[imgIndex].images ?? '',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.green,
                                    width: MediaQuery.of(context).size.width,
                                    height: 250, // or any desired height
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
                                  _carouselCurrent[index] = pos;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                feedImages.asMap().entries.map((entry) {
                                  final currentIndex =
                                      _carouselCurrent[index] ?? 0;
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
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border),
                                color: Colors.black,
                              ),
                              Text(feedItem?.totalLikes.toString() ?? '0'),
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
                              Text(feedItem?.totalComments.toString() ?? '0'),
                            ],
                          ),
                          Spacer(),

                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.bookmark_border),
                                color: Colors.black,
                              ),
                              Text('Tips '),
                              Text(feedItem?.totalCoins ?? '0'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
