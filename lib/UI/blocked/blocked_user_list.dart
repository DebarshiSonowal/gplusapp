import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BlockedUserListPage extends StatefulWidget {
  const BlockedUserListPage({Key? key}) : super(key: key);

  @override
  State<BlockedUserListPage> createState() => _BlockedUserListPageState();
}

class _BlockedUserListPageState extends State<BlockedUserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Constance.buildAppBar("blocked",true),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Consumer<DataProvider>(builder: (context, data, child) {
          return Container(
            height: 90.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = data.blockedUsers[index];
                return ListTile(
                  leading: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=932&q=80",
                          height: 150.0,
                          width: 100.0,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (cont, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Divider(
                    thickness: 0.4.h,
                  ),
                );
              },
              itemCount: data.blockedUsers.length,
            ),
          );
        }),
      ),
    );
  }
}
