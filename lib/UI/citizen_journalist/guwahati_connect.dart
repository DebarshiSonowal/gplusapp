import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class GuwahatiConnect extends StatefulWidget {
  const GuwahatiConnect({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnect> createState() => _GuwahatiConnectState();
}

class _GuwahatiConnectState extends State<GuwahatiConnect> {
  int current = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation.instance.navigate('/postClassified');
          showDialogBox();
        },
        icon: Icon(Icons.add),
        label: Text(
          "Ask a question",
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
              ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            FontAwesomeIcons.radio,
                            color: Colors.black,
                            size: 6.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Guwahati Connect',
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Constance.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Divider(
                  thickness: 0.07.h,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.separated(

                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Constance.connects.length,
                    itemBuilder: (context, count) {
                      var data = Constance.connects[count];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.title ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        color: Constance.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          data.image==null?Container():Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: SizedBox(
                              height: 25.h,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: data.image ?? "",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            data.desc ?? "",
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            data.tags ?? "",
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${data.likes} likes' ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${data.comments?.length} comments' ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.thumb_up,
                                        color: Constance.secondaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.comment,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${15} mins ago' ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: GestureDetector(
                              onTap: () {},
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Write a comment',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                              color: Colors.black,
                                            ),
                                      ),
                                      const Icon(
                                        Icons.link,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w, right: 5.w),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    Constance.connects[count].comments?.length,
                                itemBuilder: (cont, ind) {
                                  var current =
                                      Constance.connects[count].comments![ind];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              current.title ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    color:
                                                        Constance.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Icon(
                                              Icons.menu,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        current.desc ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Colors.black,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        current.tags ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${current.likes} likes' ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              '${current.comments?.length} comments' ??
                                                  "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.thumb_up,
                                                    color: Constance
                                                        .secondaryColor,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.comment,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   '${15} mins ago' ?? "",
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .headline5
                                            //       ?.copyWith(
                                            //     color: Colors.black,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Card(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 1.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Write a comment',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                  const Icon(
                                                    Icons.link,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                    ],
                                  );
                                }),
                            // child: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [],
                            // ),
                          ),
                        ],
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Divider(
                          thickness: 0.07.h,
                          color: Colors.black,
                        ),
                      );
                },),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          // Navigation.instance.navigate('/bergerMenuMem');
        },
        icon: Icon(Icons.menu),
      ),
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
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

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Guwahati Connect',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.radio,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello Jonathan!',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
