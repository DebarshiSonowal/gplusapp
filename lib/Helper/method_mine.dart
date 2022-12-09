class MethodMine{
  static Future<void> onDidReceiveBackgroundNotificationResponse(
      notificationResponse) async {
    try {
      print("notification response2 ${notificationResponse?.payload}");
    } catch (e) {
      print(e);
    }

    // Or do other work.
  }
}