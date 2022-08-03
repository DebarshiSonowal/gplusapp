import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';

import '../Helper/Constance.dart';
import 'package:sizer/sizer.dart';

class BigDealPage extends StatefulWidget {
  const BigDealPage({Key? key}) : super(key: key);

  @override
  State<BigDealPage> createState() => _BigDealPageState();
}

class _BigDealPageState extends State<BigDealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constance.secondaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      FontAwesomeIcons.spoon,
                      color: Constance.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'Food',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Constance.primaryColor,
                          fontSize: 3.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              color: Constance.primaryColor,
              height: 5.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.sort,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'Sort by',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                    child: Center(
                      child: Container(
                        height: double.infinity,
                        width: 0.5.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'Filter by',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: Constance.discounts.length,
                  itemBuilder: (cont, cout) {
                    var data = Constance.discounts[cout];
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            data.icon,
                            size: 6.h,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              data.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize:
                                        1.5.h, // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        trailing: CustomButton(
                          txt: "View",
                          onTap: () {},
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, height: 10.h, width: 20.w),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
