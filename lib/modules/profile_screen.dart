import 'dart:io';
import 'package:chat_app/modules/animate.dart';
import 'package:chat_app/modules/photo_view.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../login_screen/login_screen.dart';
import '../share/cache_helper.dart';
import '../share/components.dart';
import 'edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ChatCubit
            .get(context)
            .userModel;
        var image = ChatCubit
            .get(context)
            .image;
        return Scaffold(
          backgroundColor: ChatCubit
              .get(context)
              .isSwitch == false
              ? Colors.white
              : Colors.black,
          appBar: AppBar(
            backgroundColor: ChatCubit
                .get(context)
                .isSwitch == false
                ? Colors.white
                : Colors.black,
            elevation: 0.0,
            iconTheme: IconThemeData(
                color: ChatCubit
                    .get(context)
                    .isSwitch == false
                    ? Colors.black
                    : Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(SlideAnimate(
                            page: PhotoViewPage(imageUrl: '${ model!.image}')));
                      },
                      child: CircleAvatar(
                        radius: 85.0,
                        backgroundColor:
                        ChatCubit
                            .get(context)
                            .isSwitch == false
                            ? Colors.black
                            : Colors.white,
                        child: CircleAvatar(
                          radius: 85.0,
                          backgroundColor: Colors.black12,
                          child: Container(
                            width: 160,
                            height: 160,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: image != null
                                ? Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : SizedBox(
                              width: 100,
                              height: 100,
                              child: Image(
                                image: NetworkImage(
                                    '${ChatCubit
                                        .get(context)
                                        .userModel!
                                        .image}'), fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                      child: Text(
                        '${model!.name}',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: ChatCubit
                                .get(context)
                                .isSwitch == false
                                ? Colors.black
                                : Colors.white),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Center(
                      child: Text(
                        '${model.bio}',
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    children: [
                      Switch(
                          value: ChatCubit
                              .get(context)
                              .isSwitch,
                          onChanged: (value) {
                            CacheHelper.saveData(key: 'isDark', value: value)
                                .then((value) {
                              ChatCubit.get(context).switchChange();
                            })
                                .catchError((error) {
                              print('An Error');
                            });
                          }),
                      const SizedBox(
                        width: 10.0,
                      ),
                      defaultText(
                          text: 'Dark mode',
                          color: ChatCubit
                              .get(context)
                              .isSwitch == false
                              ? Colors.black
                              : Colors.white),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      onTap: () {
                        CacheHelper.removeData(key: 'uId').then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                              SlideAnimate(page: LoginScreen()), (
                              route) => false);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          const SizedBox(
                            width: 27.0,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                                color: ChatCubit
                                    .get(context)
                                    .isSwitch == false
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(SlideAnimate(
                              page: EditScreen()));
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                        child: const Text('Edit Profile')),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
