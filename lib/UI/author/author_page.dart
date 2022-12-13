import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class AuthorPage extends StatefulWidget {
  final int id;

  AuthorPage(this.id);

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      appBar: buildAppBar(),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 5.w,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 15.h,
                width: double.infinity,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        // padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constance.primaryColor,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                              data.author?.image_file_name ??
                                  "https://images.unsplash.com/photo-1587590834224-3247f65be147?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                              scale: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            data.author?.name ?? 'Joan Rivers',
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Follow at',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                // fontSize: 11.sp,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          children:  [
                            Icon(
                              FontAwesomeIcons.facebookSquare,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Constance.primaryColor,
                              size: 30,
                            ),
                            Icon(
                              FontAwesomeIcons.instagramSquare,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Constance.primaryColor,
                              size: 30,
                            ),
                            Icon(
                              FontAwesomeIcons.twitterSquare,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Constance.primaryColor,
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'It is a long established fact that a reader will be '
                'distracted by the readable content of a page when '
                'looking at its layout. The point of using Lorem Ipsum '
                'is that it has a more-or-less normal distribution of letters, '
                'as opposed to using. Many desktop publishing packages and'
                ' web page editors now use Lorem Ipsum as their default model'
                ' text, and a search for will uncover many web sites still in'
                ' their infancy.',
                style:
                    Theme.of(Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headline4
                        ?.copyWith(
                          color:Storage.instance.isDarkMode ? Colors.white : Colors.black,
                          // fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
              ),
            ],
          ),
        );
      }),
    );
  }

  fetchAuthorDetails(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getAuthor(id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setAuthor(response.profile!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
    }
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
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
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return Badge(
              badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Constance.thirdColor,
                ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
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
    Future.delayed(Duration.zero, () => fetchAuthorDetails(widget.id));
  }
}
