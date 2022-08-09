import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../Components/custom_button.dart';
import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class EnterPreferencesPage extends StatefulWidget {
  const EnterPreferencesPage({Key? key}) : super(key: key);

  @override
  State<EnterPreferencesPage> createState() => _EnterPreferencesPageState();
}

class _EnterPreferencesPageState extends State<EnterPreferencesPage> {
  List<String> selGeo = [];
  List<String> selTop = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(7.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tell us your preferences',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Constance.primaryColor,
                    // fontSize: 2.5.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Geographical',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Constance.primaryColor,
                    // fontSize: 2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 15.h,
              width: double.infinity,
              child: Wrap(
                children: [
                  for (int i = 0; i < Constance.geo.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!selGeo.contains(Constance.geo[i])) {
                            selGeo.add(Constance.geo[i]);
                          } else {
                            selGeo.remove(Constance.geo[i]);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: selGeo == null
                              ? Colors.white
                              : !selGeo.contains(Constance.geo[i])
                                  ? Colors.white
                                  : Constance.secondaryColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: selGeo == null
                                ? Constance.primaryColor
                                : !selGeo.contains(Constance.geo[i])
                                    ? Constance.primaryColor
                                    : Constance.secondaryColor,
                            width: 0.5.w,
                            // left: BorderSide(
                            //   color: Colors.green,
                            //   width: 1,
                            // ),
                          ),
                        ),
                        child: Text(
                          Constance.geo[i],
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Topical',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Constance.primaryColor,
                    // fontSize: 2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 15.h,
              width: double.infinity,
              child: Wrap(
                children: [
                  for (int i = 0; i < Constance.topical.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!selTop.contains(Constance.topical[i])) {
                            selTop.add(Constance.topical[i]);
                          } else {
                            selTop.remove(Constance.topical[i]);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: selTop == null
                              ? Colors.white
                              : !selTop.contains(Constance.topical[i])
                                  ? Colors.white
                                  : Constance.secondaryColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: selTop == null
                                ? Constance.primaryColor
                                : !selTop.contains(Constance.topical[i])
                                    ? Constance.primaryColor
                                    : Constance.secondaryColor,
                            width: 0.5.w,
                            // left: BorderSide(
                            //   color: Colors.green,
                            //   width: 1,
                            // ),
                          ),
                        ),
                        child: Text(
                          Constance.topical[i],
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 5.h,
              child: CustomButton(
                txt: 'Save & Continue',
                onTap: () {
                  Navigation.instance.navigateAndReplace('/main');
                },
              ),
            ),
            SizedBox(
              height: 1.h,
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
    );
  }
}
