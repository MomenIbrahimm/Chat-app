import 'package:chat_app/login_screen/login_screen.dart';
import 'package:chat_app/modules/chat_screen.dart';
import 'package:chat_app/share/bloc_observe.dart';
import 'package:chat_app/share/cache_helper.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:chat_app/share/constant.dart';
import 'package:chat_app/share/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'share/firebase_options.dart';

@pragma('vm:entry-point')



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print('Background message');
  await Firebase.initializeApp();

 await Fluttertoast.showToast(
      msg: message.messageType!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  Fluttertoast.showToast(
      msg: message.messageType!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  /// MAKE SURE EVERY THINGS DONE BEFORE THE RUN
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var token = await FirebaseMessaging.instance.getToken();
  print('Token: $token');

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    Fluttertoast.showToast(
        msg: "On Message Notify",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }) ;

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    Fluttertoast.showToast(
        msg: "On Message Notify",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId');
  isDark = CacheHelper.getData(key: 'isDark');

  late Widget widget;

  if (uId != null) {
    widget = const ChatSplashScreen();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget, isDark: isDark));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget, required this.isDark});

  final Widget startWidget;
  final bool? isDark;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getAllUsers()
        ..getUserData()
        ..switchChange(fromShared: isDark),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blueAccent,
            ),
            home: startWidget,
          );
        },
      ),
    );
  }
}
