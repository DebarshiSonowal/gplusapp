import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;

  String _poll = Constance.pollWeek[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselWithIndicatorDemo(),
              Container(
                width: double.infinity,
                height: 20.h,
                padding: EdgeInsets.symmetric(vertical: 4.5.h, horizontal: 8.w),
                child: Expanded(
                  child: Card(
                    color: Constance.thirdColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 0.5.h),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  'BIG DEALS AND OFFERS',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: Constance.kfc_offer,
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
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 25.h,
                width: double.infinity,
                color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Top picks for you',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Constance.primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (cont, count) {
                              var item = Constance.topList[count];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 10.h,
                                  width:
                                      MediaQuery.of(context).size.width - 7.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: item.image ?? '',
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
                                            Text(
                                              item.date ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name ?? "",
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Constance
                                                            .primaryColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              item.title ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
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
                              return SizedBox(
                                width: 10.w,
                              );
                            },
                            itemCount: Constance.topList.length),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 20.h,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    color: Constance.primaryColor,
                    child: Center(
                      child: Text('AD'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey.shade500,
                  thickness: 0.3.h,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                height: 25.h,
                width: double.infinity,
                // color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'GPlus Exclusive',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Constance.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (cont, count) {
                              var item = Constance.topList[count];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      width: 0.5,
                                      color: Constance.primaryColor),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 10.h,
                                  width:
                                      MediaQuery.of(context).size.width - 7.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: item.image ?? '',
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
                                            Text(
                                              item.date ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name ?? "",
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                        fontSize: 2.2.h,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Constance
                                                            .primaryColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              item.title ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
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
                              return SizedBox(
                                width: 10.w,
                              );
                            },
                            itemCount: Constance.topList.length),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Read More',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey.shade500,
                  thickness: 0.3.h,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                height: 25.h,
                width: double.infinity,
                // color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Video of the week',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Constance.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (cont, count) {
                              var item = Constance.topList[count];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      width: 0.5,
                                      color: Constance.primaryColor),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 10.h,
                                  width:
                                      MediaQuery.of(context).size.width - 7.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: CachedNetworkImage(
                                                  imageUrl: item.image ?? '',
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
                                            Text(
                                              item.date ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name ?? "",
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                        fontSize: 2.2.h,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Constance
                                                            .primaryColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              item.title ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      color: Constance
                                                          .primaryColor),
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
                              return SizedBox(
                                width: 10.w,
                              );
                            },
                            itemCount: Constance.topList.length),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey.shade500,
                        thickness: 0.3.h,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35.h,
                width: double.infinity,
                // color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Poll of the week',
                            style:
                                Theme.of(context).textTheme.headline3?.copyWith(
                                      color: Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (cont, count) {
                              var item = Constance.pollWeek[count];
                              var value = Constance.pollValue[count];
                              return Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.grey.shade900,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                child: RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  selected: _poll == item ? true : false,
                                  tileColor: Colors.grey.shade300,
                                  selectedTileColor: Colors.black,
                                  value: item,
                                  activeColor: Colors.black,
                                  groupValue: _poll,
                                  onChanged: (val) {
                                    setState(() {
                                      _poll = item;
                                    });
                                  },
                                  title: Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  secondary: Text(
                                    '${value}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.black, fontSize: 1.7.h
                                            // fontWeight: FontWeight.bold,
                                            ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (cont, inde) {
                              return SizedBox(
                                width: 10.w,
                              );
                            },
                            itemCount: Constance.pollWeek.length),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey.shade500,
                        thickness: 0.3.h,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // height: 27.h,
                width: double.infinity,
                // color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Opinion',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Constance.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (cont, count) {
                          var item = Constance.topList[count];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  width: 0.5, color: Constance.primaryColor),
                            ),
                            child: Container(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 3.w, vertical: 2.h),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Colors.white,
                              ),
                              height: 12.h,
                              width: MediaQuery.of(context).size.width - 7.w,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 2.h),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border: Border(
                                            top: BorderSide(
                                                width: 0.5,
                                                color: Constance.primaryColor),
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Constance.primaryColor),
                                            right: BorderSide(
                                                width: 0.5,
                                                color: Constance.primaryColor),
                                            left: BorderSide(
                                                width: 0.5,
                                                color: Constance.primaryColor),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.name ?? "",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.title ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Constance.thirdColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              item.date ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (cont, inde) {
                          return SizedBox(
                            width: 10.w,
                          );
                        },
                        itemCount: (Constance.topList.length / 2).toInt(),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Read More',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: current,
        onTap: (val) {
          setState(() {
            current = val;
          });
          switch(val){
            case 1:
              Navigation.instance.navigate('/bigdealpage');
              break;
            default:
              Navigation.instance.navigate('/main');
              break;
          }
        },

        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(
            fontSize: 1.5.h,
            color: Constance.secondaryColor,
            overflow: TextOverflow.clip),
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
            fontSize: 1.2.h, color: Colors.white, overflow: TextOverflow.clip),
        backgroundColor: Constance.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: current == 0 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Home",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
              color: current == 1 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Big Deal",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.radio,
              color: current == 2 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Guwahati\nConnect",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
              color: current == 3 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Citizen\nJournalist",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
              color: current == 4 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Classified",
            backgroundColor: Constance.primaryColor,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigation.instance.navigate('/bergerMenuMem');
        },
        icon: Icon(Icons.menu),
      ),
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, height: 10.h, width: 20.w),
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
}
