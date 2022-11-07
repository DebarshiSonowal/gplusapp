import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchQueryController = TextEditingController();
  int selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

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
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      5.0,
                    ), //                 <--- border radius here
                  ),
                  border: Border.all(
                      width: 1, //                   <--- border width here
                      color: Storage.instance.isDarkMode
                          ? Colors.white70
                          : Colors.black26),
                ),
                // color: Colors.black,
                // height: 5.h,
                child: Center(
                  child: TextField(
                    toolbarOptions: const ToolbarOptions(
                        copy: false, paste: false, cut: false, selectAll: false
                        //by default all are disabled 'false'
                        ),
                    controller: _searchQueryController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black26),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_searchQueryController.text.isNotEmpty) {
                            search(_searchQueryController.text, selected);
                          } else {
                            showError('Enter something to search');
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                    cursorColor: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    onChanged: (query) => {},
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color:
                      Storage.instance.isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 0;
                        });
                        search(_searchQueryController.text, selected);
                      },
                      child: Container(
                        height: 5.h,
                        color: selected == 0
                            ? Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black
                            : Constance.secondaryColor,
                        child: Center(
                          child: Text(
                            'News',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                    color: selected == 0
                                        ? Storage.instance.isDarkMode
                                            ? Colors.black
                                            : Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 1;
                        });
                        search(_searchQueryController.text, selected);
                      },
                      child: Container(
                        height: 5.h,
                        color: selected == 1
                            ? Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black
                            : Constance.secondaryColor,
                        child: Center(
                          child: Text(
                            'Others',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: selected == 1
                                          ? Storage.instance.isDarkMode
                                              ? Colors.black
                                              : Colors.white
                                          : Colors.black,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color:Storage.instance.isDarkMode
                      ? Colors.white
                      : Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (cont, count) {
                      var item = data.searchlist[count];
                      return GestureDetector(
                        onTap: () {
                          Navigation.instance.navigate('/story',
                              args:
                                  '${item.first_cat_name?.seo_name},${item.seo_name}');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Storage.instance.isDarkMode
                                ? Colors.black
                                :Colors.white,
                          ),
                          height: 20.h,
                          width: MediaQuery.of(context).size.width - 7.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CachedNetworkImage(
                                        imageUrl: item.image_file_name ?? '',
                                        fit: BoxFit.fill,
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
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      item.publish_date?.split(" ")[0] ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors.black),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title ?? "",
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                color: Storage.instance.isDarkMode
                                                    ? Colors.white
                                                    :Constance.primaryColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      item.author_name ?? "GPlus News",
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Constance.thirdColor,
                                            // fontSize: 2.2.h,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                :Colors.black,
                            thickness: 0.3.sp,
                          ),
                        ),
                      );
                    },
                    itemCount: data.searchlist.length),
              ),
            ],
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
    );
  }

  void search(query, type) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.search(query, type);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSearchResult(response.data!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
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
}
