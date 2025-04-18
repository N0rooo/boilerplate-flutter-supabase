class Constants {
  static const List<String> topics = [
    'Business',
    'Technology',
    'Programming',
    'Entertainment',
  ];

  static const String noConnectionErrorMessage = 'Not connected to a network';
}

class SupabaseTables {
  static const String blogs = 'blogs';
  static const String profiles = 'profiles';
  static const String messages = 'messages';
  static const String chatRooms = 'chat_rooms';
  static const String chatParticipants = 'chat_participants';
}

class SupabaseViews {
  static const String userChatRooms = 'user_chat_rooms';
}

class FilterDefaultMatrix {
  static const List<double> defaultMatrix = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
}
