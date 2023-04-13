import 'package:chat_app/login_screen/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatLoginCubit extends Cubit<ChatLoginState> {
  ChatLoginCubit() : super(InitialLoginState());

  static ChatLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.remove_red_eye;

  void isChange() {
    isPassword = !isPassword;
    isPassword
        ? suffix = Icons.remove_red_eye
        : suffix = Icons.remove_red_eye_outlined;
    emit(ShowPassState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          emit(ChatLoginSuccessState(value.user!.uid));
    })
        .catchError((error) {
      emit(ChatLoginErrorState(error.toString()));
      print(error.toString());
    });
  }
}
