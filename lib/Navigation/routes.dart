import 'package:flutter/material.dart';

import 'package:gplusapp/OnBoarding/SplashScreen.dart';

import '../Authentication/Signin/login_page.dart';
import '../Authentication/Signup/signup_page.dart';

import '../Authentication/enter_preferences_page.dart';
import '../Authentication/personal_details_page.dart';
import '../Authentication/terms&conditions_page.dart';
import '../Authentication/verifyotp_page.dart';
import '../Components/FadeTransitionBuilder.dart';
import '../Components/loading_dialog.dart';
import '../OnBoarding/on_boarding_page.dart';
import '../UI/Member/be_a_membe_page.dart';
import '../UI/Menu/berger_menu_member_page.dart';
import '../UI/Notification/notification_page.dart';
import '../UI/VideoReport/video_report.dart';
import '../UI/citizen_journalist/guwahati_connect.dart';
import '../UI/citizen_journalist/submit_story.dart';
import '../UI/classified/classified_details.dart';
import '../UI/classified/classified_page.dart';
import '../UI/classified/post_a_listing.dart';
import '../UI/deals/big_deal_page.dart';
import '../UI/deals/category_select_page.dart';
import '../UI/deals/filter_page.dart';
import '../UI/deals/food_deal_page.dart';
import '../UI/deals/redeem_offer_page.dart';
import '../UI/edit_profile/edit_profile_page.dart';
import '../UI/exclusive_page/exclusive_page.dart';
import '../UI/main/home_screen_page.dart';
import '../UI/opinion/opinion_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeTransitionPageRouteBuilder(page: SplashScreen());
    case '/onboarding':
      return FadeTransitionPageRouteBuilder(page: OnBoardingPage());

    //login pages
    case '/login':
      return FadeTransitionPageRouteBuilder(page: LoginPage());
    case '/signup':
      return FadeTransitionPageRouteBuilder(page: SignupPage());
    case '/verifyOtp':
      return FadeTransitionPageRouteBuilder(page: VerifyOTP(settings.arguments as int));
    case '/terms&conditions':
      return FadeTransitionPageRouteBuilder(page: TermsAndConditions());
    case '/personaldetails':
      return FadeTransitionPageRouteBuilder(page: PersonalDetailsPage());
    case '/editProfile':
      return FadeTransitionPageRouteBuilder(page: EditProfile());
    case '/enterPreferences':
      return FadeTransitionPageRouteBuilder(page: EnterPreferencesPage());

    case '/loadingDialog':
      return FadeTransitionPageRouteBuilder(page: LoadingDialog());

    case '/bigdealpage':
      return FadeTransitionPageRouteBuilder(page: BigDealPage());
    case '/redeemOfferPage':
      return FadeTransitionPageRouteBuilder(page: RedeemOfferPage());
    case '/fooddealpage':
      return FadeTransitionPageRouteBuilder(page: FoodDealPage());
    case '/filterPage':
      return FadeTransitionPageRouteBuilder(page: FilterPage());
    case '/categorySelect':
      return FadeTransitionPageRouteBuilder(page: CategorySelectPage());

    case '/notification':
      return FadeTransitionPageRouteBuilder(page: NotificationPage());
    case '/beamember':
      return FadeTransitionPageRouteBuilder(page: BeAMember());
    case '/exclusivePage':
      return FadeTransitionPageRouteBuilder(page: ExclusivePage());
    case '/opinionPage':
      return FadeTransitionPageRouteBuilder(page: OpinionPage());
    case '/videoReport':
      return FadeTransitionPageRouteBuilder(page: VideoReport());

    case '/submitStory':
      return FadeTransitionPageRouteBuilder(page: SubmitStoryPage());

    case '/classified':
      return FadeTransitionPageRouteBuilder(page: ClassifiedPage());
    case '/classifiedDetails':
      return FadeTransitionPageRouteBuilder(page: ClassifiedDetails());
    case '/postClassified':
      return FadeTransitionPageRouteBuilder(page: PostAListing());
    case '/guwahatiConnects':
      return FadeTransitionPageRouteBuilder(page: GuwahatiConnect());

    //Main
    case '/main':
      return FadeTransitionPageRouteBuilder(page: HomeScreen());

    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text('404 Page not found'),
          ),
        );
      });
  }
}
