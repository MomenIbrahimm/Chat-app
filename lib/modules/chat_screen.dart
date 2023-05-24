import 'package:buildcondition/buildcondition.dart';
import 'package:chat_app/modules/chat_details.dart';
import 'package:chat_app/modules/profile_screen.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:chat_app/share/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user_model.dart';
import 'animate.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ChatCubit.get(context).userModel;
        return Scaffold(
          backgroundColor: ChatCubit.get(context).isSwitch==false?Colors.white:Colors.black,
          appBar: AppBar(
            title: const Text('Chats'),
            actions: [
              BuildCondition(
                condition: ChatCubit.get(context).userModel != null,
                builder: (context)=> Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(SlideAnimate(page: const ProfileScreen()));
                    },
                    child:  CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${model!.image}'),
                    ),
                  ),
                ),
                fallback:(context)=> const Center(child: CircularProgressIndicator()) ,
              )
            ],
            backgroundColor: ChatCubit.get(context).isSwitch==false?Colors.white:Colors.black,
            titleTextStyle:  TextStyle(
                color: ChatCubit.get(context).isSwitch==false?Colors.black:Colors.white,
                fontSize: 22.5,
                fontWeight: FontWeight.bold),
            elevation: 0.0,
          ),
          body: BuildCondition(
            condition: ChatCubit.get(context).userModel != null,
            builder: (context) => Column(
              children: [
                if (!FirebaseAuth.instance.currentUser!.emailVerified)
                  Container(
                    color: Colors.amber.withOpacity(.7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const Text('verification your email'),
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification()
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Check your mail')));
                                })
                                    .catchError((error) {
                                });
                              },
                              child: const Text(
                                'SEND',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: BuildCondition(
                    condition: ChatCubit.get(context).userModel != null && ChatCubit.get(context).users != null,
                    builder: (context)=>ListView.builder(
                      itemBuilder: (context, index) {
                        return buildChatUser(ChatCubit.get(context).users![index],context);
                      },
                      itemCount: ChatCubit.get(context).users!.length,
                    ),
                    fallback: (context)=>  Container(),
                  ),
                ),
              ],
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  buildChatUser(UserModel model,context) {
    return InkWell(
      onTap: () {
        navigateTo(context,ChatDetails(model: model,));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
             CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(
                  '${model.image}'),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                '${model.name}',
                style: TextStyle(fontSize: 18.0,color: ChatCubit.get(context).isSwitch==false?Colors.black:Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
