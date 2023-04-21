import 'package:upgrader/upgrader.dart';

class MyCustomMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String? message(UpgraderMessage messageKey) {
    if (languageCode == 'en') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return "\nA new version of G Plus is now available Would you like to update it now?";
        case UpgraderMessage.buttonTitleIgnore:
          return 'Ignore';
        case UpgraderMessage.buttonTitleLater:
          return 'Later';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Update Now';
        case UpgraderMessage.prompt:
          return '';
        case UpgraderMessage.title:
          return 'Update App?';
        case UpgraderMessage.releaseNotes:
          return "A new Version of Upgrader";
        default:
          return "";
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey);
  }
}
