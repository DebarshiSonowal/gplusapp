import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/OnBoarding/SplashScreen.dart';
import 'package:gplusapp/UI/EmergencyPage/emergency_page.dart';
import 'package:gplusapp/UI/classified/classified_mylist_page.dart';
import 'package:gplusapp/UI/main/sections/loading_router.dart';
import 'package:gplusapp/UI/update_profile_details/update_profile_details.dart';
import 'package:gplusapp/UI/view/no_internet_connection_page.dart';

import '../Authentication/Signin/login_page.dart';
import '../Authentication/Signup/signup_page.dart';
import '../Authentication/enter_preferences_page.dart';
import '../Authentication/location_search_page.dart';
import '../Authentication/personal_details_page.dart';
import '../Authentication/terms&conditions_page.dart';
import '../Authentication/verifyotp_page.dart';
import '../Components/FadeTransitionBuilder.dart';
import '../Components/loading_dialog.dart';
import '../Components/story_view.dart';
import '../Components/video_player_screen.dart';

// import '../OnBoarding/on_boarding_page.dart';
import '../Helper/Storage.dart';
import '../Payment/payment_processing_page.dart';
import '../UI/Member/be_a_membe_page.dart';
import '../UI/Notification/notification_page.dart';
import '../UI/Search/search_page.dart';
import '../UI/VideoReport/video_report.dart';
import '../UI/author/author_page.dart';
import '../UI/blocked/blocked_user_list.dart';
import '../UI/category/category_details.dart';
import '../UI/category/category_page.dart';
import '../UI/citizen_journalist/citizen_journalist_page.dart';
import '../UI/citizen_journalist/draft_story.dart';
import '../UI/citizen_journalist/edit_story.dart';
import '../UI/citizen_journalist/stories_submitted.dart';
import '../UI/citizen_journalist/submit_story.dart';
import '../UI/citizen_journalist/view_story_page.dart';
import '../UI/classified/classified_details.dart';
import '../UI/classified/classified_page.dart';
import '../UI/classified/edit_a_listing.dart';
import '../UI/classified/post_a_listing.dart';
import '../UI/deals/big_deal_page.dart';
import '../UI/deals/category_select_page.dart';
import '../UI/deals/filter_page.dart';
import '../UI/deals/food_deal_page.dart';
import '../UI/deals/redeem_offer_page.dart';
import '../UI/edit_profile/edit_address_page.dart';
import '../UI/edit_profile/edit_profile_page.dart';
import '../UI/edit_profile/edit_saved_addresses.dart';
import '../UI/exclusive_page/exclusive_page.dart';
import '../UI/guwahati_connect/all_images_page.dart';
import '../UI/guwahati_connect/ask_a_question.dart';
import '../UI/guwahati_connect/edit_ask_a_question.dart';
import '../UI/guwahati_connect/guwahati_connect_mylist_page.dart';
import '../UI/guwahati_connect/guwahati_connect_page.dart';
import '../UI/main/home_screen_page.dart';
import '../UI/news_from/news_from.dart';
import '../UI/opinion/opinion_details_page.dart';
import '../UI/opinion/opinion_page.dart';
import '../UI/others/about_us_page.dart';
import '../UI/others/advertise_with_us_page.dart';
import '../UI/others/blocked_list_page.dart';
import '../UI/others/bookmarks_page.dart';
import '../UI/others/contact_us_page.dart';
import '../UI/others/grievanceRedressal.dart';
import '../UI/others/link_failed_page.dart';
import '../UI/others/privacy_policy_page.dart';
import '../UI/others/refund_policy_page.dart';
import '../UI/others/settings_page.dart';
import '../UI/others/terms_conditions_page.dart';
import '../UI/poll_of_the week/poll_page.dart';
import '../UI/profile/profile_page.dart';
import '../UI/refer_earn/redeem_points.dart';
import '../UI/refer_earn/refer&earn.dart';
import '../UI/story/story_page.dart';
import '../UI/toppicks/top_picks_page.dart';
import '../UI/view/competition_dynamic_page.dart';
import '../UI/view/full_screen_advertisement.dart';
import '../UI/view/view_image_page.dart';
import '../UI/view/webview_payment.dart';
import 'Navigate.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // if (settings.name == null || settings.name == "") {
  //   return FadeTransitionPageRouteBuilder(page: HomeScreen());
  // }
  switch (settings.name) {
    // case null:
    //   debugPrint("It's here");
    //   FirebaseAnalytics.instance.setCurrentScreen(screenName: 'home');
    //   return FadeTransitionPageRouteBuilder(page: const HomeScreen());
    case '/':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'splash_screen');
      return FadeTransitionPageRouteBuilder(page: const SplashScreen());
    // case '/onboarding':
    //   FirebaseAnalytics.instance.setCurrentScreen(screenName: 'on_boarding');
    //   return FadeTransitionPageRouteBuilder(page: const OnBoardingPage());

    //login pages
    case '/login':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'login');
      return FadeTransitionPageRouteBuilder(page: const LoginPage());
    case '/signup':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'register');
      return FadeTransitionPageRouteBuilder(page: const SignupPage());
    case '/verifyOtp':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'verify_otp');
      return FadeTransitionPageRouteBuilder(
          page: VerifyOTP(settings.arguments as int));
    case '/terms&conditions':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'terms_conditions');
      return FadeTransitionPageRouteBuilder(
          page: TermsAndConditions(settings.arguments as int));
    case '/personaldetails':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'enter_details');
      return FadeTransitionPageRouteBuilder(
          page: PersonalDetailsPage(settings.arguments as int));
    case '/editProfile':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'update_profile');
      return FadeTransitionPageRouteBuilder(page: const EditProfile());
    case '/editSavedAddresses':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'edit_address');
      return FadeTransitionPageRouteBuilder(
          page: EditSavedAddresses(
        which: settings.arguments as int,
      ));


    case '/updateProfile':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'signup_profile');
      return FadeTransitionPageRouteBuilder(page: const UpdateProfileDetails());
    case '/profile':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'subscription');
      return FadeTransitionPageRouteBuilder(page: const ProfilePage());
    case '/enterPreferences':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'enter_preferences');
      return FadeTransitionPageRouteBuilder(page: const EnterPreferencesPage());
    case '/locationSearchPage':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'location_search');
      return FadeTransitionPageRouteBuilder(page: const LocationSearchPage());

    case '/loadingDialog':
      return FadeTransitionPageRouteBuilder(page: LoadingDialog());
    case '/no_internet':
      return FadeTransitionPageRouteBuilder(
          page: const NoInternetConnectionScreen());
    case '/fullScreenAd':
      return FadeTransitionPageRouteBuilder(page: FullScreenAdvertisement());
    case '/videoPlayer':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'video_player');
      return FadeTransitionPageRouteBuilder(
          page: VideoPlayerScreen(settings.arguments as String));
    case '/viewImage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'view_image');
      return FadeTransitionPageRouteBuilder(
          page: ViewImagePage(settings.arguments as String));
    // case '/websitePayment':
    //   return FadeTransitionPageRouteBuilder(
    //       page: WebviewPayment(url: settings.arguments as String));

    case '/bigdealpage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'bigdeal');
      return FadeTransitionPageRouteBuilder(page: const BigDealPage());
    case '/redeemOfferPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'cupon_details');
      return FadeTransitionPageRouteBuilder(page: const RedeemOfferPage());
    case '/fooddealpage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'deal');
      return FadeTransitionPageRouteBuilder(
          page: FoodDealPage(settings.arguments as int));
    case '/filterPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'filter');
      return FadeTransitionPageRouteBuilder(page: const FilterPage());
    case '/pollPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'poll_page');
      return FadeTransitionPageRouteBuilder(page: const PollPage());
    case '/categorySelect':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'redeem_offer');
      return FadeTransitionPageRouteBuilder(
          page: CategorySelectPage(settings.arguments as int));
    case '/story':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'article_detail');
      return FadeTransitionPageRouteBuilder(
          page: StoryPage(settings.arguments as String));
    case '/categoryStory':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'category');
      return FadeTransitionPageRouteBuilder(
          page: CategoryDetails(slug: settings.arguments as String));
    case '/paymentProcessing':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'payment_processing');
      return FadeTransitionPageRouteBuilder(
          page: paymentProcessingPage(settings.arguments as String));
    // case '/paymentProcessingIOS':
    //   return FadeTransitionPageRouteBuilder(
    //       page: Webview_payment(url: settings.arguments as String));

    case '/notification':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'notification');
      return FadeTransitionPageRouteBuilder(page: const NotificationPage());
    case '/blockedUsers':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'blocked');
      return FadeTransitionPageRouteBuilder(page: const BlockedUsersListPage());
    case '/bookmarks':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'bookmark');
      return FadeTransitionPageRouteBuilder(page: const BookmarksPage());
    case '/beamember':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'subscription');
      return FadeTransitionPageRouteBuilder(page: const BeAMember());
    case '/exclusivePage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'exclusive');
      return FadeTransitionPageRouteBuilder(page: const ExclusivePage());
    case '/settingsPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'settings');
      return FadeTransitionPageRouteBuilder(page: const SettingsPage());
    case '/newsfrom':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'news_from');
      return FadeTransitionPageRouteBuilder(
        page: NewsFrom(
          settings.arguments as String,
        ),
      );
    case '/category':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'category_page');
      return FadeTransitionPageRouteBuilder(
        page: CategoryPage(
          categ: settings.arguments as String,
        ),
      );
    case '/opinionPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'opinion');
      return FadeTransitionPageRouteBuilder(
          page: OpinionPage(type: settings.arguments as String));
    case '/opinionDetails':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'opinion_detail');
      return FadeTransitionPageRouteBuilder(
          page: OpinionDetailsPage(settings.arguments as String));
    case '/videoReport':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'video_report');
      return FadeTransitionPageRouteBuilder(
          page: VideoReport(settings.arguments as String));

    case '/contactUs':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'contact_us');
      return FadeTransitionPageRouteBuilder(page: const ContactUsPage());

    case '/submitStory':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'citizen_journalist');
      return FadeTransitionPageRouteBuilder(page: const SubmitStoryPage());
    case '/submitedStory':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'submitted_story');
      return FadeTransitionPageRouteBuilder(page: const StoriesSubmitted());
    case '/draftStory':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'drafts');
      return FadeTransitionPageRouteBuilder(page: const DraftStory());
    case '/authorPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'author');
      return FadeTransitionPageRouteBuilder(
          // page: AuthorPage(int.parse((settings.arguments as String).split(",")[0]),(settings.arguments as String).split(",")[1]));
          page: AuthorPage(settings.arguments as int));
    case '/storyviewPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'story_view');
      return FadeTransitionPageRouteBuilder(
          page: StoryViewPage(settings.arguments as int));

    case '/classified':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'classified');
      return FadeTransitionPageRouteBuilder(page: const ClassifiedPage());
    case '/toppicks':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'toppicks_page');
      return FadeTransitionPageRouteBuilder(page: const TopPicksPage());
    case '/refer&earn':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'refer_earn');
      return FadeTransitionPageRouteBuilder(page: const ReferAndEarn());
    case '/redeemPoints':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'redeem_points');
      return FadeTransitionPageRouteBuilder(page: const RedeemPoints());
    case '/classifiedDetails':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'classified_details');
      return FadeTransitionPageRouteBuilder(
          page: ClassifiedDetails(settings.arguments as int));
    case '/editAddress':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'edit_address');
      return FadeTransitionPageRouteBuilder(
          page: EditAddressPage(settings.arguments as int));
    case '/classifiedMyListDetails':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'my_classified_page');
      return FadeTransitionPageRouteBuilder(page: const ClassifiedMyList());
    case '/citizenJournalist':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'citizen_journalist');
      return FadeTransitionPageRouteBuilder(
          page: const CitizenJournalistPage());
    case '/editCitizenJournalist':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'edit_citizen_journalist');
      return FadeTransitionPageRouteBuilder(
          page: EditStory(settings.arguments as int));
    case '/viewStoryPage':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'view_story_page');
      return FadeTransitionPageRouteBuilder(
          page: ViewStoryPage(settings.arguments as int));
    case '/postClassified':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'post_classified');
      return FadeTransitionPageRouteBuilder(page: const PostAListing());
    case '/editingAListing':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'editing_listing');
      return FadeTransitionPageRouteBuilder(
          page: EditAListingPost(settings.arguments as int));
    case '/guwahatiConnects':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'guwahati');
      return FadeTransitionPageRouteBuilder(page: const GuwahatiConnectPage());
    case '/guwahatiConnectsMy':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'my_guwahati_connect');
      return FadeTransitionPageRouteBuilder(
          page: const GuwahatiConnectMylistPage());
    case '/allImagesPage':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'allimages_page');
      return FadeTransitionPageRouteBuilder(
          page: AllImagePage(settings.arguments as int));
    case '/askAQuestion':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'ask_a_question');
      return FadeTransitionPageRouteBuilder(page: const AskAQuestionPage());
    case '/editAskAQuestion':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'edit_a_question');
      return FadeTransitionPageRouteBuilder(
          page: EditAskAQuestionPage(settings.arguments as String));
    case '/search':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'search');
      return FadeTransitionPageRouteBuilder(
          page: SearchPage(query: settings.arguments as String));
    case '/aboutUs':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'about_us');
      return FadeTransitionPageRouteBuilder(page: const AboutUsPage());
    case '/refundPolicy':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'refund_policy');
      return FadeTransitionPageRouteBuilder(page: const ReturnPolicyPage());
    case '/termsConditions':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'terms_conditions');
      return FadeTransitionPageRouteBuilder(page: const TermsConditionsPage());
    case '/privacy':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'privacy_policy');
      return FadeTransitionPageRouteBuilder(page: const PrivacyPolicyPage());
    case '/grieveanceRedressal':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'grieveance_redressal');
      return FadeTransitionPageRouteBuilder(page: const GrieveanceRedressal());

    case '/advertiseWithUs':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'advertise_with_us');
      return FadeTransitionPageRouteBuilder(page: const AdvertiseWithUsPage());
    case '/blockedUserList':
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'blocked_userlist');
      return FadeTransitionPageRouteBuilder(page: const BlockedUserListPage());
    case '/competitions':
      return FadeTransitionPageRouteBuilder(page: CompetitionDynamicPage(url: settings.arguments as String, ));
    case '/emergency':
      return FadeTransitionPageRouteBuilder(
          page: EmergencyPage(title: settings.arguments as String,
      ));

    //Main
    case '/main':
      FirebaseAnalytics.instance.setCurrentScreen(screenName: 'home');
      return FadeTransitionPageRouteBuilder(page: const HomeScreen());
    // case '/bergerMenuMem':
    //   return FadeTransitionPageRouteBuilder(page: BergerMenuMemPage());
    // case null:
    //   return FadeTransitionPageRouteBuilder(page: HomeScreen());
    case '/link_failed':
      debugPrint("MyPath");
      return FadeTransitionPageRouteBuilder(
          page: LinkFailedPage(
        path: settings.arguments as String,
      ));
    case '/mainWithAnimation':
      return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return const HomeScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.1, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      );

    default:
      return FadeTransitionPageRouteBuilder(
          page: LoadingRouter(deepLink: settings.name ?? ""));
  }
}
