import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class StoryPage extends StatefulWidget {
  final int? id;

  StoryPage(this.id);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int random = 0;
  var categories = ['international', 'assam', 'guwahati', 'india'];
  var dropdownvalue = 'international';

  @override
  void initState() {
    super.initState();
    fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 25.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(
                    //   // Radius.circular(10),
                    // ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        data.home_exclusive[0].image_file_name ??
                            'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Container(
                            color: Constance.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            child: Text(
                              'Guwahati',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 2.2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        data.home_exclusive[0].title ??
                            'It is a long established fact that a reader will be distracted by the readable content of a',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline3
                            ?.copyWith(
                              color: Constance.primaryColor,
                              // fontSize: 2.2.h,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        '${data.home_exclusive[0].author_name}, ${data.home_exclusive[0].publish_date?.split(" ")[0]}',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline5
                            ?.copyWith(
                              color: Colors.black,
                              // fontSize: 2.2.h,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.thumb_up,
                              color: Constance.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.thumb_down,
                              color: Constance.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.comment,
                              color: Constance.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.share,
                              color: Constance.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black45,
                                    // fontWeight: FontWeight.bold,
                                  ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Guwahati: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const TextSpan(
                              text: 'standard dummy text ever since the 1500s,'
                                  ' when an unknown printer took a galley'
                                  ' of type and scrambled it to make a type '
                                  'specimen book. It has survived not only five'
                                  ' centuries, but also the leap into electronic '
                                  'typesetting, remaining essentially unchanged.'
                                  ' It was popularised in the 1960s with the release'
                                  ' of Letraset sheets containing Lorem Ipsum passages,'
                                  ' and more recently with desktop publishing software'
                                  ' like Aldus PageMaker including versions of Lorem Ipsum',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            _launchUrl(
                                Uri.parse(data.ads[random].link.toString()));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.5.h),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: data.ads[random].image_file_name ?? '',
                              placeholder: (cont, _) {
                                return const Icon(
                                  Icons.image,
                                  color: Colors.black,
                                );
                              },
                              errorWidget: (cont, _, e) {
                                // print(e);
                                print(_);
                                return Text(_);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black45,
                                    // fontWeight: FontWeight.bold,
                                  ),
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'standard dummy text ever since the 1500s,'
                                  ' when an unknown printer took a galley'
                                  ' of type and scrambled it to make a type '
                                  'specimen book. It has survived not only five'
                                  ' centuries, but also the leap into electronic '
                                  'typesetting, remaining essentially unchanged.'
                                  ' It was popularised in the 1960s with the release'
                                  ' of Letraset sheets containing Lorem Ipsum passages,'
                                  ' and more recently with desktop publishing software'
                                  ' like Aldus PageMaker including versions of Lorem Ipsum',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.07.h,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.thumb_up,
                              color: Constance.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.thumb_down,
                              color: Constance.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.comment,
                              color: Constance.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.share,
                              color: Constance.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.07.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Related Stories',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Constance.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Sort by categories',
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                  color: Colors.black,
                                  // fontSize: 2.2.h,
                                  // fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .black26, //                   <--- border color
                                // width: 5.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      5.0) //                 <--- border radius here
                                  ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: DropdownButton(
                              isExpanded: false,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                  ),
                              underline: SizedBox.shrink(),
                              // Initial Value
                              value: dropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: categories.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (cont, count) {
                            var item = data.home_exclusive[count];
                            if (count != 0) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 2.h),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.white,
                                ),
                                height: 20.h,
                                width: MediaQuery.of(context).size.width - 7.w,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  item.image_file_name ?? '',
                                              fit: BoxFit.fill,
                                              placeholder: (cont, _) {
                                                return const Icon(
                                                  Icons.image,
                                                  color: Colors.black,
                                                );
                                              },
                                              errorWidget: (cont, _, e) {
                                                // print(e);
                                                print(_);
                                                return Text(_);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            item.publish_date?.split(" ")[0] ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title ?? "",
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Constance
                                                          .primaryColor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            item.author_name ?? "GPlus News",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                          separatorBuilder: (cont, inde) {
                            if (inde == 0) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 1.h,
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 0.3.sp,
                                ),
                              );
                            }
                          },
                          itemCount: data.home_exclusive.length > 5
                              ? 5
                              : data.home_exclusive.length),
                      SizedBox(
                        height: 4.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigation.instance.navigate('/bergerMenuMem');
      //   },
      //   icon: Icon(Icons.menu),
      // ),
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
            // showSearch(
            //   context: context,
            //   delegate: SearchPage<Listing>(
            //     items: Constance.listings,
            //     searchLabel: 'Search posts',
            //     suggestion: Center(
            //       child: Text(
            //         'Filter posts by name, descr',
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //     ),
            //     failure: const Center(
            //       child: Text('No posts found :('),
            //     ),
            //     filter: (current) => [
            //       current.title,
            //       current.descr,
            //       // person.age.toString(),
            //     ],
            //     builder: (data) => ListTile(
            //       title: Text(
            //         data.title ?? "",
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //       subtitle: Text(
            //         data.descr ?? '',
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //       // trailing: CachedNetworkImage(
            //       //   imageUrl: data.image??'',
            //       //   height: 20,
            //       //   width: 20,
            //       // ),
            //     ),
            //   ),
            // );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void fetchAds() async {
    final response = await ApiProvider.instance.getAdvertise();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAds(response.ads ?? []);
      random = Random().nextInt(response.ads?.length ?? 0);
    }
  }
}
