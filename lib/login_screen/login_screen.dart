import 'package:chat_app/login_screen/login_cubit.dart';
import 'package:chat_app/login_screen/login_state.dart';
import 'package:chat_app/modules/animate.dart';
import 'package:chat_app/share/cache_helper.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../modules/chat_screen.dart';
import '../register/register_screen.dart';
import '../share/components.dart';
import '../share/constant.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatLoginCubit(),
      child: BlocConsumer<ChatLoginCubit, ChatLoginState>(
        listener: (context, state) {
          if (state is ChatLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, const ChatScreen());
              uId = state.uId;
              ChatCubit.get(context).getUserData();
              ChatCubit.get(context).getAllUsers();
              successSnackBar(context: context, text: 'Login Successfully');
            });
          } else if (state is ChatLoginWithGoogleSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              Navigator.of(context).pushAndRemoveUntil(SlideAnimate(page: const ChatScreen()), (route) => false);
              uId = state.uId;
              ChatCubit.get(context).getUserData();
              ChatCubit.get(context).getAllUsers();
              successSnackBar(context: context, text: 'Login Successfully');
            });
          } else if (state is ChatLoginErrorState) {
            if (state.error.toString() ==
                '[firebase_auth/invalid-email] The email address is badly formatted.') {
              errorSnackBar(
                  context: context,
                  text: 'The email address is badly formatted');
            } else if (state.error.toString() ==
                '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
              errorSnackBar(
                  context: context,
                  text:
                      'here is no user record corresponding to this identifier');
            } else if (state.error.toString() ==
                '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
              errorSnackBar(context: context, text: 'The password is invalid');
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                requestFocus(context);
              },
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/logImage.jpg'),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50.0,
                          ),
                          defaultText(
                              text: 'User Login',
                              size: 30,
                              color: Colors.white),
                          const SizedBox(
                            height: 10,
                          ),
                          LottieBuilder.asset('assets/login.json',height: 100.0,width: 100,),
                          const SizedBox(
                            height: 70.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white70),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  defaultTextFormField(
                                    controller: emailController,
                                    context: context,
                                    keyBoardTyp: TextInputType.emailAddress,
                                    text: 'email address',
                                    prefixIcon: const Icon(Icons.email),
                                    validateText: 'email field is empty',
                                    onSubmitted: () {},
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultTextFormField(
                                    controller: passController,
                                    context: context,
                                    keyBoardTyp: TextInputType.visiblePassword,
                                    text: 'password',
                                    obscure:
                                        ChatLoginCubit.get(context).isPassword,
                                    prefixIcon: const Icon(Icons.lock),
                                    validateText: 'password field is empty',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          ChatLoginCubit.get(context)
                                              .isChange();
                                        },
                                        icon: Icon(ChatLoginCubit.get(context)
                                            .suffix)),
                                    onSubmitted: () {},
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  defaultMaterialButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          ChatLoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passController.text,
                                          );
                                        }
                                      },
                                      text: 'login',
                                      isUpperCase: true),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {
                                       ChatLoginCubit.get(context)
                                              .signInWithGoogle();
                                        },
                                        child: state is ChatLoginWithGoogleLoadingState? const Center(child: CircularProgressIndicator(strokeWidth: 1.7,)):Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LottieBuilder.asset(
                                              'assets/google.json',
                                              height: 60.0,
                                              width: 60.0,
                                              fit: BoxFit.cover,
                                            ),
                                            defaultText(
                                                text: 'Sign in with Google'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      defaultText(
                                          text: 'don\'t have an account?',
                                          size: 14.0),
                                      defaultTextButton(
                                          onPressed: () {
                                            navigateAndReplace(context,
                                                const RegisterScreen());
                                          },
                                          text: 'Register',
                                          fontWeight: FontWeight.bold,
                                          size: 17.0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
