import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: Constance.notifications.length,
          itemBuilder: (cont, count) {
            var current = Constance.notifications[count];
            return Container(
              decoration: BoxDecoration(
                  color: count==0?Color(0xffcde3f2):Colors.white,
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
              ),
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.4.h),
              width: double.infinity,
              height: 14.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${current.title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headline4
                        ?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      Icon(current.icon,color: Constance.primaryColor,),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        '${current.author}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline6
                            ?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        Jiffy(current.date, "dd-MM-yyyy")
                            .fromNow()??'${current.date}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline6
                            ?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // color: Colors.red,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 1.h,
            );
          },
        ),
      ),
    );
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
    );
  }
}
