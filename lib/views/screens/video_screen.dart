import 'package:clips/views/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/video_controller.dart';
import '../../values.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          return PageView.builder(
            itemCount: videoController.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = videoController.videoList[index];
              return Stack(
                children: [
                  VideoPlayerItem(
                    videoUrl: data.videoUrl,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    buildProfile(
                                      data.profilePhoto,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          data.username,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data.caption,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.music_note,
                                              size: 14,
                                              color: borderColor,
                                            ),
                                            Text(
                                              data.songName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: borderColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () => videoController.likeVideo(data.id),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 36,
                                          color: data.likes.contains(authController.user.uid)
                                              ? Colors.red
                                              : secondaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.likes.length.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: secondaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () => {},
                                        // onTap: () => Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) => CommentScreen(
                                        //       id: data.id,
                                        //     ),
                                        //   ),
                                        //),
                                        child: const Icon(
                                          Icons.comment,
                                          size: 36,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.commentCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: secondaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Transform.flip(
                                          flipX: true,
                                          child: const Icon(
                                            Icons.reply,
                                            size: 36,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.shareCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: secondaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
