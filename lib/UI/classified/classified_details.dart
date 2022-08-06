
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class ClassifiedDetails extends StatefulWidget {
  const ClassifiedDetails({Key? key}) : super(key: key);

  @override
  State<ClassifiedDetails> createState() => _ClassifiedDetailsState();
}

class _ClassifiedDetailsState extends State<ClassifiedDetails> {
  var current=4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselWithIndicatorDemo(),
              SizedBox(
                height: 2.h,
              ),
              Text(
                '2BHK for Rent',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Constance.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Posted by Jonathan Doe',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Rs: 15000',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: Constance.thirdColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: Text(
                        'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                        // overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: Text(
                        '4999 views',
                        // overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Text(
                'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                    ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                    ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                    ' remaining essentially unchanged',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(txt: 'Call Jonathan', onTap:(){
                  showDialogBox();
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
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
  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Post your listing',
            style: Theme.of(context).textTheme.headline1?.copyWith(
              color: Constance.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.newspaper,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello Jonathan!',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
