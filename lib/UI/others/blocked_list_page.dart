import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/blocked_user.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Menu/berger_menu_member_page.dart';

class BlockedUsersListPage extends StatefulWidget {
  const BlockedUsersListPage({Key? key}) : super(key: key);

  @override
  State<BlockedUsersListPage> createState() => _BlockedUsersListPageState();
}

class _BlockedUsersListPageState extends State<BlockedUsersListPage> {
  bool isEmpty = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      // appBar: Constance.buildAppBar("blocked",true,_scaffoldKey),
      appBar: Constance.buildAppBar2("blocked"),
      // drawer: const BergerMenuMemPage(screen: "blocked",),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Blocked Users",
                    style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headline3
                        ?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.secondaryColor,
                          // fontSize: 2.2.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Consumer<DataProvider>(builder: (context, data, widg) {
              return data.blockedUsers.isEmpty
                  ? Center(
                      child: Lottie.asset(
                        isEmpty
                            ? Constance.noDataLoader
                            : Constance.searchingIcon,
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item = data.blockedUsers[index];
                          return ListTile(
                            title: Text(
                              item.user?.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                            subtitle: Text(
                              item.user?.city ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                            ),
                            leading: blockedUserImage(item: item),
                            trailing: SizedBox(
                              width: 22.w,
                              height: 3.h,
                              child: CustomButton(
                                txt: 'Unblock',
                                onTap: () {
                                  unblockUser(item.user_id,item.block_for);
                                },
                                size: 10.sp,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (cont, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: Divider(
                              thickness: 0.02.h,
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        },
                        itemCount: data.blockedUsers.length,
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      debugPrint("Here");
      fetchBlockedUsersList();
    });
  }

  void fetchBlockedUsersList() async {
    final response = await ApiProvider.instance.blockedUsers();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setBlockedUsers(response.blocked ?? []);
      setState(() {
        isEmpty = false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  void unblockUser(int? id, String? categ) async{
    final response = await ApiProvider.instance.unblockUser(id, categ);
    if(response.success??false){
      Fluttertoast.showToast(msg: response.message??"");
      fetchBlockedUsersList();
    }else{
      Fluttertoast.showToast(msg: response.message??"Something went wrong");
    }
  }
}

class blockedUserImage extends StatelessWidget {
  const blockedUserImage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BlockedUser item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(
        item.user?.image_file_name ??
            "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=932&q=80",
        height: 5.h,
        width: 10.w,
        fit: BoxFit.fill,
        errorBuilder: (cont, obj, err) {
          return Image.network(
            "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=932&q=80",
            height: 5.h,
            width: 10.w,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
