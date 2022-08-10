import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../Menu/berger_menu_member_page.dart';

class BeAMember extends StatefulWidget {
  const BeAMember({Key? key}) : super(key: key);

  @override
  State<BeAMember> createState() => _BeAMemberState();
}

class _BeAMemberState extends State<BeAMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Jonathan!',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Be a Member',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Constance.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'when an unknown printer took a galley of type'
                ' and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Card(
                color: Color(0xff011727),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get the Monthly Subscription',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Rs 99/',
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            'month',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          txt: 'Get it',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Card(
                color: Constance.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get the Yearly Subscription',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Rs 999/',
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            'year',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Text(
                        '* You save Rs 119',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          txt: 'Get it',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Benefits of being a member',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Constance.benifits.length,
                  itemBuilder: (cont, count) {
                    var data = Constance.benifits[count];
                    return SizedBox(
                      height: 10.h,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.h,
                            width: 1.h,
                            margin: EdgeInsets.only(top: 1.h),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 10.h,
                              child: Column(
                                children: [
                                  Text(
                                    data,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 1.5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, scale: 2,),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
