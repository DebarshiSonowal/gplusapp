import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class CitizenJournalist extends StatefulWidget {
  const CitizenJournalist({Key? key}) : super(key: key);

  @override
  State<CitizenJournalist> createState() => _CitizenJournalistState();
}

class _CitizenJournalistState extends State<CitizenJournalist> {
  int current = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      drawer: BergerMenuMemPage(),
      bottomNavigationBar: CustomNavigationBar(current),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        // height: 50.h,
        // width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Be a Journalist',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Constance.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Icon(
              FontAwesomeIcons.radio,
              color: Constance.secondaryColor,
              size: 15.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Hello Jonathan!',
              style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
              ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
              ' It has survived not only five centuries, but also the leap into electronic typesetting,'
              ' remaining essentially unchanged',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
            Spacer(),
            SizedBox(
              height: 5.h,
              width: double.infinity,
              child: CustomButton(
                  txt: 'Submit a Story',
                  onTap: () {
                    Navigation.instance.navigate('/submitStory');
                  }),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 5.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Constance.primaryColor),
                ),
                onPressed: () {
                  Navigation.instance.navigate('/draftStory');
                },
                child: Text(
                  'Drafts',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.white,
                    fontSize: 14.5.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 5.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  // Navigation.instance.goBack();
                  Navigation.instance.navigate('/submitedStory');
                },
                child: Text(
                  'Stories submitted',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.white,
                    fontSize: 14.5.sp,
                  ),
                ),
              ),
            ),
          ],
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
