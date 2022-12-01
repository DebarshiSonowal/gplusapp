import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/Constance.dart';
import '../../../Navigation/Navigate.dart';

class StoriesSection extends StatefulWidget {
  final DataProvider data;

  const StoriesSection({super.key, required this.data});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  int current = 0, currentPage = 0;
  final _listController = PageController(keepPage: true, viewportFraction: 0.8);

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40.h,
          child: PageView.builder(
              // allowImplicitScrolling: true,
              controller: _listController,
              // shrinkWrap: true,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              scrollDirection: Axis.horizontal,
              itemCount: widget.data.stories.length,
              itemBuilder: (cont, index) {
                var current = widget.data.stories[index];
                return GestureDetector(
                  onTap: () {
                    Navigation.instance.navigate('/storyviewPage', args: index);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: 70.w,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: current.image_file_name ?? "",
                            width: double.infinity,
                            // height:55.h,
                            height: 40.h,
                            fit: BoxFit.fill,
                            // filterQuality: FilterQuality.low,
                            placeholder: (cont, _) {
                              return Image.asset(
                                Constance.logoIcon,
                                // color: Colors.black,
                              );
                            },
                            errorWidget: (cont, _, e) {
                              return Image.network(
                                Constance.defaultImage,
                                fit: BoxFit.fitWidth,
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black]),
                          ),
                          // color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                current.title ?? 'Big Deals\nand Offers',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.grey.shade200,
                                        fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              // Text(
                              //   "${current.author_name?.trim()}, ${Jiffy(current.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .headline6
                              //       ?.copyWith(
                              //         color: Colors.white,
                              //       ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        widget.data.stories.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.data.stories.length; i++)
                    Container(
                      width: (i <= (widget.data.stories.length / 2.toInt()))
                          ? 2.w
                          : (i >= (widget.data.stories.length - 2))
                              ? 1.25.w
                              : 1.65.w,
                      height: (i <= (widget.data.stories.length / 2.toInt()))
                          ? 2.h
                          : (i >= (widget.data.stories.length - 2))
                              ? 1.25.w
                              : 1.65.w,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == currentPage
                            ? Constance.secondaryColor
                            : Colors.grey.shade800,
                      ),
                    ),
                ],
              )
            : Container(),
      ],
    );
  }
}
