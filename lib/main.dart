import 'package:chat_app/login_screen/login_screen.dart';
import 'package:chat_app/modules/chat_screen.dart';
import 'package:chat_app/share/bloc_observe.dart';
import 'package:chat_app/share/cache_helper.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:chat_app/share/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'share/firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId');
  isDark = CacheHelper.getData(key: 'isDark');

 late Widget widget;

  if(uId != null)
    {
      widget = const ChatScreen();
    }else{
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget,isDark: isDark,));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.startWidget,required this.isDark});

  final Widget startWidget;
  final bool? isDark;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ChatCubit()..getUserData()..getAllUsers()..switchChange(fromShared: isDark),
      child: BlocConsumer<ChatCubit,ChatState>(
        listener:(context,state){},
        builder:(context,state){
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
