import 'package:chat_app/register/register_cubit.dart';
import 'package:chat_app/register/register_state.dart';
import 'package:chat_app/share/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, ChatRegisterState>(
        listener: (context, state) {
         if(state is CreateUsersSuccessState)
           {
             navigateTo(context, LoginScreen());
           }
        },
        builder: (context, state) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                requestFocus(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/logImage.jpg'),fit: BoxFit.cover)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultText(
                            text: 'Create an account',
                            size: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Icon(
                            Icons.create,
                            color: Colors.black,
                            size: 50.0,
                          ),
                          const SizedBox(height: 30.0,),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white70,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  defaultTextFormField(
                                    controller: nameController,
                                    keyBoardTyp: TextInputType.emailAddress,
                                    text: 'Name',
                                    prefixIcon: const Icon(Icons.person),
                                    context: context,
                                    onSubmitted: (String value) {
                                      if (formKey.currentState!.validate()) {}
                                    },
                                    validateText: 'the email field is empty',
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    controller: phoneController,
                                    keyBoardTyp: TextInputType.phone,
                                    text: 'Phone',
                                    prefixIcon: const Icon(Icons.phone),
                                    context: context,
                                    onSubmitted: (String value) {
                                      if (formKey.currentState!.validate()) {}
                                    },
                                    validateText: 'the email field is empty',
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    controller: emailController,
                                    keyBoardTyp: TextInputType.emailAddress,
                                    text: 'Email address',
                                    prefixIcon: const Icon(Icons.email),
                                    context: context,
                                    onSubmitted: (String value) {
                                      if (formKey.currentState!.validate()) {
                                      }
                                    },
                                    validateText: 'the email field is empty',
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    controller: passController,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isPassword = !isPassword;
                                          });
                                        },
                                        icon: isPassword
                                            ? const Icon(Icons.remove_red_eye)
                                            : const Icon(Icons.remove_red_eye_outlined)),
                                    keyBoardTyp: TextInputType.visiblePassword,
                                    text: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    context: context,
                                    obscure: isPassword,
                                    onSubmitted: (String value) {
                                      if (formKey.currentState!.validate()) {
                                      }
                                    },
                                    validateText: 'the password field is empty',
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  defaultMaterialButton(onPressed: (){
                                    if (formKey.currentState!.validate()) {
                                      RegisterCubit.get(context).userRegister(
                                        email: emailController.text,
                                        pass: passController.text,
                                        name: nameController.text,
                                        phone: phoneController.text);
                                    }
                                  }, text: 'register',isUpperCase: true),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      defaultText(
                                          text: 'Already have an account?', size: 14.0),
                                      defaultTextButton(
                                          onPressed: () {
                                            navigateAndReplace(context, LoginScreen());
                                          },
                                          text: 'Sign in',
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
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

