import 'dart:io';
import 'package:chat_app/modules/photo_view.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:chat_app/share/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        var image = ChatCubit.get(context).image;
        nameController.text = ChatCubit.get(context).userModel!.name!;
        phoneController.text = ChatCubit.get(context).userModel!.phone!;
        emailController.text = ChatCubit.get(context).userModel!.email!;
        bioController.text = ChatCubit.get(context).userModel!.bio!;

        return Scaffold(
          backgroundColor: ChatCubit.get(context).isSwitch==false?Colors.white:Colors.black,
          appBar: AppBar(
            backgroundColor: ChatCubit.get(context).isSwitch==false?Colors.white:Colors.black,
            elevation: 0.0,
            iconTheme: IconThemeData(color: ChatCubit.get(context).isSwitch==false?Colors.black:Colors.white),
          ),
          body: GestureDetector(
            onTap: () {
              requestFocus(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is UserUpdateLoadingState)
                      const LinearProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: 200,
                        child: Stack(alignment: Alignment.bottomRight, children: [
                          Center(
                            child: InkWell(
                              onTap:(){
                                navigateTo(context, PhotoViewPage(imageUrl: ChatCubit.get(context).userModel!.image!));
                              },
                              child: CircleAvatar(
                                radius: 85.0,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 85.0,
                                  backgroundColor: ChatCubit.get(context).isSwitch==false?Colors.black:Colors.white,
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
                                                  '${ChatCubit.get(context).userModel!.image}')),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: IconButton(
                                  onPressed: () {
                                    ChatCubit.get(context).getProfileImage();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    if (ChatCubit.get(context).image != null)
                      SizedBox(
                          width: 150.0,
                          child: OutlinedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                              onPressed: () {
                                ChatCubit.get(context).uploadImage(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text);
                              },
                              child: const Text('Update Image'))),
                    if (state is UploadImageLoadingState)
                      const SizedBox(
                          width: 150.0, child: LinearProgressIndicator()),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            defaultTextFormField(
                              controller: nameController,
                              keyBoardTyp: TextInputType.text,
                              text: 'Name',
                              prefixIcon: const Icon(Icons.person),
                              onSubmitted: () {},
                              context: context,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            defaultTextFormField(
                              controller: emailController,
                              keyBoardTyp: TextInputType.text,
                              text: 'Email Address',
                              prefixIcon: const Icon(Icons.email),
                              onSubmitted: () {},
                              context: context,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            defaultTextFormField(
                              controller: phoneController,
                              keyBoardTyp: TextInputType.phone,
                              text: 'Phone',
                              prefixIcon: const Icon(Icons.phone),
                              onSubmitted: () {},
                              context: context,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            defaultTextFormField(
                              controller: bioController,
                              keyBoardTyp: TextInputType.text,
                              text: 'Bio',
                              prefixIcon: const Icon(Icons.info_outline),
                              onSubmitted: () {},
                              context: context,
                            ),
                            defaultMaterialButton(
                                onPressed: () {
                                  ChatCubit.get(context).updateUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                text: 'Save'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
