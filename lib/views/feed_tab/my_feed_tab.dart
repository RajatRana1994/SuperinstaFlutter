import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/feed_tab/add_feed_tab.dart';
import 'package:get/get.dart';
import 'package:instajobs/dialogs/ask_dialog.dart';
import 'package:instajobs/views/feed_tab/feed_detail_vc.dart';
import '../../models/feed_tab_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'inline_video_player.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

class MyFeedTab extends StatefulWidget {
  const MyFeedTab({super.key});

  @override
  State<MyFeedTab> createState() => _MyFeedTabState();
}

class _MyFeedTabState extends State<MyFeedTab> with BaseClass {
  FeedTabController feedTabController = Get.put(FeedTabController());
  final Map<int, int> _carouselCurrent = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedTabController.getMyFeedData();
    feedTabController.getAppSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              pushToNextScreen(context: context, destination: AddFeedTab());
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.orange,
              size: 30,
            ),
          ),
        ],
        title: Text(
          'My Feeds',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<FeedTabController>(
        init: feedTabController,
        builder: (snapshot) {
          final feedList = feedTabController.feedMyList;

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

              return GestureDetector(
                onTap: () {
                  feedTabController.feedDetail.value = null;
                  int feedId = feedItem?.id ?? 0;
                  pushToNextScreen(context: context, destination: FeedDetailVc(feedId: feedId.toString()));
                },
                child: Card(
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
                          onPressed: () async {
                            final result = await showCupertinoConfirmDialog(
                              context: context,
                              title: 'Delete Feed!?',
                              description:
                              'Are you sure to delete your Feed item. Please re-check and confirm.',
                            );

                            if (result == true) {
                              int feedId = feedItem?.id ?? 0;
                              feedTabController.deleteMyFeed(feedId.toString(), index);
                            } else if (result == false) {
                              // user pressed No
                            } else {
                              // dialog dismissed
                            }
                          },
                          icon: Icon(Icons.delete),
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
                                    var feedId = feedItem?.id ?? 0;
                                    feedTabController.saveFeedData(feedId.toString(), index, type: 2);
                                  },
                                  icon: Icon( (feedItem?.isLike == 0) ? Icons.favorite_border : Icons.favorite),
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
                                GestureDetector(
                                  onTap: () async{
                                    AppSettingBodyModel? boostFeedSetting = feedTabController.appSetting?.firstWhere(
                                          (e) => e.name == "Boost Feed",
                                      orElse: () => AppSettingBodyModel(value: "0"),
                                    );
                                    String boostCoinPrice = boostFeedSetting?.value ?? "0";
                                    final result = await showCupertinoConfirmDialog(
                                      context: context,
                                      title: 'Boost Feed!',
                                      description:
                                      'Boost Feed will help you to show your feed on the top of the list. It will encourage more users to contact with you. \n\n Are you sure to Boost your Feed with $boostCoinPrice coins.',
                                    );

                                    if (result == true) {
                                      int feedId = feedItem?.id ?? 0;
                                      feedTabController.boostMyFeed(feedId.toString(), boostCoinPrice);
                                    } else if (result == false) {
                                      // user pressed No
                                    } else {
                                      // dialog dismissed
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2), // background color
                                      borderRadius: BorderRadius.circular(20), // round corners
                                    ),
                                    child: Text(
                                      'BOOST FEED',
                                      style: TextStyle(color: Colors.red),
                                      // text color white for contrast
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5),
                                Text('Tips '),
                                Text(feedItem?.totalCoins ?? '0'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
