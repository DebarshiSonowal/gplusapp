import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:provider/provider.dart';

import 'Helper/AppTheme.dart';
import 'Helper/Constance.dart';
import 'Helper/DataProvider.dart';
import 'Navigation/Navigate.dart';
import 'Navigation/routes.dart';
import 'package:sizer/sizer.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.instance.initializeStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>DataProvider(),
      child: Sizer(
          builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GPLUS',
            theme: AppTheme.getTheme(),
            navigatorKey: Navigation.instance.navigatorKey,
            onGenerateRoute: generateRoute,
          );
        }
      ),
    );
  }
}


