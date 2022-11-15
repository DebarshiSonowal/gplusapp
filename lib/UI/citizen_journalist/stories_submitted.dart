import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class StoriesSubmitted extends StatefulWidget {
  const StoriesSubmitted({Key? key}) : super(key: key);

  @override
  State<StoriesSubmitted> createState() => _StoriesSubmittedState();
}

class _StoriesSubmittedState extends State<StoriesSubmitted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stories Submitted',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.4.sp,
                  ),
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
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigation.instance.navigate(
                                                '/viewStoryPage',
                                                args: item.id);
                                          },
                                          child: Text(
                                            item.title ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Storage
                                                            .instance.isDarkMode
                                                        ? Colors.white
                                                        : Constance
                                                            .primaryColor),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
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
                                                        color: Storage.instance
                                                                .isDarkMode
                                                            ? Colors.white70
                                                            : Colors.black),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            item.status==0?"Pending":"Approved",
                                            style: Theme.of(Navigation
                                                    .instance
                                                    .navigatorKey
                                                    .currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Storage
                                                          .instance.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  // fontSize: 2.2.h,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

  fetchDrafts() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getCitizenJournalistApproved();
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
          onPressed: () {},
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {},
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
  @override
  void dispose() {

    super.dispose();
    // Provider.of<DataProvider>(
    //     Navigation.instance.navigatorKey.currentContext ?? context,
    //     listen: false)
    //     .setCitizenJournalist([]);
  }
}
