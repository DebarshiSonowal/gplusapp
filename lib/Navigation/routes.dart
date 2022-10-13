import 'package:flutter/material.dart';

import 'package:gplusapp/OnBoarding/SplashScreen.dart';

import '../Authentication/Signin/login_page.dart';
import '../Authentication/Signup/signup_page.dart';

import '../Authentication/enter_preferences_page.dart';
import '../Authentication/location_search_page.dart';
import '../Authentication/personal_details_page.dart';
import '../Authentication/terms&conditions_page.dart';
import '../Authentication/verifyotp_page.dart';
import '../Components/FadeTransitionBuilder.dart';
import '../Components/loading_dialog.dart';
import '../Components/video_player_screen.dart';
import '../OnBoarding/on_boarding_page.dart';
import '../UI/Member/be_a_membe_page.dart';
import '../UI/Menu/berger_menu_member_page.dart';
import '../UI/Notification/notification_page.dart';
import '../UI/Search/search_page.dart';
import '../UI/VideoReport/video_report.dart';
import '../UI/author/author_page.dart';
import '../UI/citizen_journalist/citizen_journalist_page.dart';
import '../UI/citizen_journalist/draft_story.dart';
import '../UI/citizen_journalist/edit_story.dart';
import '../UI/guwahati_connect/ask_a_question.dart';
import '../UI/guwahati_connect/guwahati_connect_page.dart';
import '../UI/citizen_journalist/stories_submitted.dart';
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
import '../UI/edit_profile/edit_saved_addresses.dart';
import '../UI/exclusive_page/exclusive_page.dart';
import '../UI/main/home_screen_page.dart';
import '../UI/news_from/news_from.dart';
import '../UI/opinion/opinion_page.dart';
import '../UI/others/about_us_page.dart';
import '../UI/others/contact_us_page.dart';
import '../UI/others/grievanceRedressal.dart';
import '../UI/others/privacy_policy_page.dart';
import '../UI/profile/profile_page.dart';
import '../UI/refer_earn/redeem_points.dart';
import '../UI/refer_earn/refer&earn.dart';
import '../UI/opinion/opinion_details_page.dart';
import '../UI/story/story_page.dart';

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
      return FadeTransitionPageRouteBuilder(
          page: VerifyOTP(settings.arguments as int));
    case '/terms&conditions':
      return FadeTransitionPageRouteBuilder(
          page: TermsAndConditions(settings.arguments as int));
    case '/personaldetails':
      return FadeTransitionPageRouteBuilder(
          page: PersonalDetailsPage(settings.arguments as int));
    case '/editProfile':
      return FadeTransitionPageRouteBuilder(page: EditProfile());
    case '/editSavedAddresses':
      return FadeTransitionPageRouteBuilder(page: EditSavedAddresses());

    case '/profile':
      return FadeTransitionPageRouteBuilder(page: ProfilePage());
    case '/enterPreferences':
      return FadeTransitionPageRouteBuilder(page: EnterPreferencesPage());
    case '/locationSearchPage':
      return FadeTransitionPageRouteBuilder(page: LocationSearchPage());

    case '/loadingDialog':
      return FadeTransitionPageRouteBuilder(page: LoadingDialog());
    case '/videoPlayer':
      return FadeTransitionPageRouteBuilder(
          page: VideoPlayerScreen(settings.arguments as String));

    case '/bigdealpage':
      return FadeTransitionPageRouteBuilder(page: BigDealPage());
    case '/redeemOfferPage':
      return FadeTransitionPageRouteBuilder(page: RedeemOfferPage());
    case '/fooddealpage':
      return FadeTransitionPageRouteBuilder(
          page: FoodDealPage(settings.arguments as int));
    case '/filterPage':
      return FadeTransitionPageRouteBuilder(page: FilterPage());
    case '/categorySelect':
      return FadeTransitionPageRouteBuilder(
          page: CategorySelectPage(settings.arguments as int));
    case '/story':
      return FadeTransitionPageRouteBuilder(
          page: StoryPage(settings.arguments as String));

    case '/notification':
      return FadeTransitionPageRouteBuilder(page: NotificationPage());
    case '/beamember':
      return FadeTransitionPageRouteBuilder(page: BeAMember());
    case '/exclusivePage':
      return FadeTransitionPageRouteBuilder(page: ExclusivePage());
    case '/newsfrom':
      return FadeTransitionPageRouteBuilder(
        page: NewsFrom(
          settings.arguments as String,
        ),
      );
    case '/opinionPage':
      return FadeTransitionPageRouteBuilder(page: OpinionPage());
    case '/opinionDetails':
      return FadeTransitionPageRouteBuilder(
          page: OpinionDetailsPage(settings.arguments as String));
    case '/videoReport':
      return FadeTransitionPageRouteBuilder(page: VideoReport());

    case '/contactUs':
      return FadeTransitionPageRouteBuilder(page: ContactUsPage());

    case '/submitStory':
      return FadeTransitionPageRouteBuilder(page: SubmitStoryPage());
    case '/submitedStory':
      return FadeTransitionPageRouteBuilder(page: StoriesSubmitted());
    case '/draftStory':
      return FadeTransitionPageRouteBuilder(page: DraftStory());
    case '/authorPage':
      return FadeTransitionPageRouteBuilder(
          page: AuthorPage(settings.arguments as int));

    case '/classified':
      return FadeTransitionPageRouteBuilder(page: ClassifiedPage());
    case '/refer&earn':
      return FadeTransitionPageRouteBuilder(page: ReferAndEarn());
    case '/redeemPoints':
      return FadeTransitionPageRouteBuilder(page: RedeemPoints());
    case '/classifiedDetails':
      return FadeTransitionPageRouteBuilder(
          page: ClassifiedDetails(settings.arguments as int));
    case '/citizenJournalist':
      return FadeTransitionPageRouteBuilder(page: CitizenJournalistPage());
    case '/editCitizenJournalist':
      return FadeTransitionPageRouteBuilder(
          page: EditStory(settings.arguments as int));
    case '/postClassified':
      return FadeTransitionPageRouteBuilder(page: PostAListing());
    case '/guwahatiConnects':
      return FadeTransitionPageRouteBuilder(page: GuwahatiConnectPage());
    case '/askAQuestion':
      return FadeTransitionPageRouteBuilder(page: AskAQuestionPage());
    case '/search':
      return FadeTransitionPageRouteBuilder(page: SearchPage());
    case '/aboutUs':
      return FadeTransitionPageRouteBuilder(page: AboutUsPage());
    case '/privacy':
      return FadeTransitionPageRouteBuilder(page: PrivacyPolicyPage());
    case '/grieveanceRedressal':
      return FadeTransitionPageRouteBuilder(page: GrieveanceRedressal());

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
