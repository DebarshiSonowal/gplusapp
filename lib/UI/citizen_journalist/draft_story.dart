import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class DraftStory extends StatefulWidget {
  const DraftStory({Key? key}) : super(key: key);

  @override
  State<DraftStory> createState() => _DraftStoryState();
}

class _DraftStoryState extends State<DraftStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drafts',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: Storage.instance.isDarkMode
                      ? Colors.white
                      : Constance.primaryColor,
                  thickness: 0.2.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                data.citizenlist.isEmpty
                    ? EmptyWidget(
                        image: Constance.logoIcon,
                        title: 'Oops!',
                        subTitle: 'No stories are submitted yet',
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Constance.primaryColor),
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Constance.secondaryColor),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (cont, count) {
                          var item = data.citizenlist[count];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            height: 12.h,
                            width: MediaQuery.of(context).size.width - 7.w,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigation.instance.navigate(
                                            '/viewStoryPage',
                                            args: item.id);
                                      },
                                      child: SizedBox(
                                        width: 20.w,
                                        child: Text(
                                          item.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Storage
                                                          .instance.isDarkMode
                                                      ? Colors.white
                                                      : Constance.primaryColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigation.instance.navigate(
                                                '/viewStoryPage',
                                                args: item.id);
                                          },
                                          child: Text(
                                            item.story ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Storage
                                                            .instance.isDarkMode
                                                        ? Colors.white70
                                                        : Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigation.instance.navigate(
                                                    '/editCitizenJournalist',
                                                    args: item.id);
                                              },
                                              child: Text(
                                                "Edit",
                                                style: Theme.of(Navigation
                                                        .instance
                                                        .navigatorKey
                                                        .currentContext!)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      color: Storage.instance
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      // fontSize: 2.2.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                deletePost(item.id);
                                              },
                                              child: Text(
                                                "Delete",
                                                style: Theme.of(Navigation
                                                        .instance
                                                        .navigatorKey
                                                        .currentContext!)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      color:
                                                          Constance.thirdColor,
                                                      // fontSize: 2.2.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (cont, inde) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: SizedBox(
                              height: 1.h,
                              child: Divider(
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                thickness: 0.3.sp,
                              ),
                            ),
                          );
                        },
                        itemCount: data.citizenlist.length),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
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
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDrafts());
  }

  deletePost(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteCitizenJournalist(id);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: 'Deleted Succesfully');
      Navigation.instance.goBack();
      fetchDrafts();
    } else {
      Navigation.instance.goBack();
    }
  }

  fetchDrafts() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getCitizenJournalistDraft();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCitizenJournalist(response.posts);
      // Fluttertoast.showToast(msg: "G successfully");
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }
}
