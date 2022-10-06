import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
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
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(
          builder: (context,data,_) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stories Submitted',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.primaryColor, fontWeight: FontWeight.bold),
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
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (cont, count) {
                        var item = data.citizenlist[count];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white,
                          ),
                          height: 12.h,
                          width: MediaQuery.of(context).size.width - 7.w,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title?? "",
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            color: Constance.primaryColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:  Text(
                                            item.story?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          "Approved",
                                          style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                            color: Colors.black,
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
                              color: Colors.black,
                              thickness: 0.3.sp,
                            ),
                          ),
                        );
                      },
                      itemCount:data.citizenlist.length),
                ],
              ),
            );
          }
        ),
      ),
    );
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
  AppBar buildAppBar() {
    return AppBar(
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDrafts());
  }
}
