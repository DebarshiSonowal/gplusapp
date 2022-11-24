import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/shop.dart';
import '../Navigation/Navigate.dart';
import 'custom_button.dart';

class ShopTypePageItem extends StatelessWidget {
  const ShopTypePageItem({
    Key? key,
    required this.current,
  }) : super(key: key);

  final Shop current;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            // height: 6.h,
            width: 16.w,
            imageUrl: current.image_file_name ?? "",
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                current.shop_name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 2.2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                current.address ?? "",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade800,
                      fontSize: 1.5.h, // fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        trailing: CustomButton(
          txt: "View",
          onTap: () {
            if (Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .profile
                    ?.is_plan_active ??
                false) {
              Navigation.instance.navigate('/categorySelect', args: current.id);
            } else {
              Constance.showMembershipPrompt(context, () {});
            }
          },
        ),
      ),
    );
  }
}
