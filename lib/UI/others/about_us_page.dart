import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Constance.secondaryColor,
                    size: 3.5.h,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'About Us',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Constance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Center(
                child: Text(
                  Constance.about,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publisher & Editor in Chief',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sunit Jain',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'sunit.jain@g-plus.in',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chief Executive Officer',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sidharth Bedi Varma',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'sidharth.bedivarma@g-plus.in',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chief Of Bureau',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rahul Chanda',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'rahul.chanda@g-plus.in',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              //Deputy Editor
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deputy Editor',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Chetan Bhattarai',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'chetan_bhattarai@g-plus.in',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Analyst',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Vidhi Jain',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'vidhi.jain@insightbrandcom.com',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Analyst',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Vidhi Jain',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'vidhi.jain@insightbrandcom.com',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            'Plus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Editorial Team Info',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            '\nPlus is owned by Insight Media, a unit of Insight'
                            'Brandcom Pvt. Ltd and published by Sunit Jain.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'G Plus on Wiki\n',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const TextSpan(
                        text:
                            'https://en.wikipedia.org/wiki/G Plus',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigation.instance.navigate('/bergerMenuMem');
      //   },
      //   icon: Icon(Icons.menu),
      // ),
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
            // showSearch(
            //   context: context,
            //   delegate: SearchPage<Listing>(
            //     items: Constance.listings,
            //     searchLabel: 'Search posts',
            //     suggestion: Center(
            //       child: Text(
            //         'Filter posts by name, descr',
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //     ),
            //     failure: const Center(
            //       child: Text('No posts found :('),
            //     ),
            //     filter: (current) => [
            //       current.title,
            //       current.descr,
            //       // person.age.toString(),
            //     ],
            //     builder: (data) => ListTile(
            //       title: Text(
            //         data.title ?? "",
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //       subtitle: Text(
            //         data.descr ?? '',
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //       // trailing: CachedNetworkImage(
            //       //   imageUrl: data.image??'',
            //       //   height: 20,
            //       //   width: 20,
            //       // ),
            //     ),
            //   ),
            // );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
