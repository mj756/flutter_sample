import '../model/extra_functionality/video.dart';
import '../view/extra_functionality/chat_user_list.dart';
import '../view/extra_functionality/database_operation.dart';
import '../view/extra_functionality/firestore_database.dart';
import '../view/extra_functionality/googlead_view.dart';
import '../view/extra_functionality/map.dart';
import '../view/home.dart';
import '../view/language_selection.dart';
import '../view/login.dart';
import '../view/profile.dart';
import '../view/sign_up.dart';
import '../view/splash_screen.dart';

final routes = {
  '/splash': (context) => const SplashScreen(),
  '/login': (context) => LoginPage(),
  '/profile': (context) => ProfileScreen(),
  '/signup': (context) => SignUpPage(),
  '/home': (context) => HomePage(),
  '/language': (context) => const SelectLanguage(),
  '/map': (context) => GoogleView(),
  '/chatting': (context) => const ChatUserList(),
  '/database': (context) => DatabaseOperation(),
  '/firestorage': (context) => FirebaseDatabaseOperation(),
  '/video': (context) => VideoPlayerView(),
  '/advertisement': (context) => BannerAdPage(),
};
