import 'package:chat_app/login_screen/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';

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
    }).catchError((error) {
      emit(ChatLoginErrorState(error.toString()));
      print(error.toString());
    });
  }

  signInWithGoogle() async{
    emit(ChatLoginWithGoogleLoadingState());

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential =GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken ,
      idToken: googleAuth.idToken
    );
  FirebaseAuth.instance.signInWithCredential(credential).then((value){

  userCreate(email: value.user!.email!, name: value.user!.displayName!, uId: value.user!.uid, phone: '+0', image: value.user!.photoURL!);

    emit(ChatLoginWithGoogleSuccessState(value.user!.uid));

  }).catchError((error){
    emit(ChatLoginWithGoogleErrorState(error.toString()));
    print(error.toString());
  });
  }
  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
    required String image,
  })async {
    emit(CreateUsersLoadingState());

    UserModel userModel = UserModel(
        name: name,
        email: email,
        uId: uId,
        phone: phone,
        emailVerify: false,
        bio: 'write your bio',
        image: image
    );

  await  FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateUsersWithGoogleSuccessState());
    }).catchError((error) {
      emit(CreateUsersWithGoogleErrorState(error.toString()));
    });
  }
}
