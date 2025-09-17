import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:get/get.dart';

import '../../models/feed_tab_model.dart';
import '../../utils/app_colors.dart';
import 'package:instajobs/views/feed_tab/inline_video_player.dart';


class FeedFavPage extends StatefulWidget {
  const FeedFavPage({super.key});

  @override
  State<FeedFavPage> createState() => _FeedFavPageState();
}

// class _FeedFavPageState extends State<FeedFavPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class _FeedFavPageState extends State<FeedFavPage> {
  FeedTabController feedTabController = Get.put(FeedTabController());
  final Map<int, int> _carouselCurrent = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedTabController.getSavedFavData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: GetBuilder<FeedTabController>(
        init: feedTabController,
        builder: (snapshot) {
          final feedList = feedTabController.feedFavList;

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
                  feedItem?.feeds?.feedImages
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
                            feedItem?.feeds?.users?.profile ?? '',
                          ),
                        ),
                      ),
                      title: Text(feedItem?.feeds?.users?.name ?? ''),

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
                      child: Text(feedItem?.feeds?.description ?? ''),
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
                            itemCount: feedImages.isNotEmpty ? feedImages.length : 1,
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
                                loadingBuilder: (context, child, loadingProgress) {
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
                                onPressed: () {
                                  var feedId = feedItem?.feeds?.id ?? 0;
                                  feedTabController.saveFeedData(feedId.toString(), index, type: 1);
                                },
                                icon: Icon( (feedItem?.feeds?.isLike == 0) ? Icons.favorite_border : Icons.favorite),
                                color: Colors.black,
                              ),
                              Text(feedItem?.feeds?.totalLikes.toString() ?? '0'),
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
                              Text(feedItem?.feeds?.totalComments.toString() ?? '0'),
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
                              Text(feedItem?.feeds?.totalCoins ?? '0'),
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
