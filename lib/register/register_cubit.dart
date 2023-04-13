import 'package:bloc/bloc.dart';
import 'package:chat_app/register/register_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user_model.dart';

class RegisterCubit extends Cubit<ChatRegisterState> {
  RegisterCubit() : super(InitialChatState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required email,
    required pass,
    required name,
    required phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      userCreate(email: email, name: name, phone: phone, uId: value.user!.uid);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    emit(CreateUsersLoadingState());

    UserModel userModel = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        emailVerify: false,
        bio: 'write your bio',
        image:
            'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png');

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateUsersSuccessState());
    }).catchError((error) {
      emit(CreateUsersErrorState(error.toString()));
    });
  }
}
