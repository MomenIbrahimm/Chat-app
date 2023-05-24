import 'dart:io';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/share/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(InitialChatState());

  static ChatCubit get(context) => BlocProvider.of(context);


  bool isSwitch = false;

  void switchChange({bool? fromShared}){
    if(fromShared != null)
      {
        isSwitch = fromShared;
      }else{
      isSwitch = !isSwitch;
    }

    emit(ChangeSwitch());
    print(isSwitch);
  }

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingChatState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessChatState());
    }).catchError((error) {
      emit(GetUserErrorChatState());
      print(error.toString());
    });
  }

  XFile? image;
  ImagePicker pickedFile = ImagePicker();

  Future getProfileImage() async {
    image = await pickedFile.pickImage(source: ImageSource.gallery);
    if (image != null) {
      image = XFile(image!.path);
      print(image!.path);
      emit(PickedImageSuccessState());
    } else {
      print('no image select');
      emit(PickedImageErrorState());
    }
  }

  XFile? chatImage;
  ImagePicker pickedChatFile = ImagePicker();

  Future getChatImage() async {
    chatImage = await pickedChatFile.pickImage(source: ImageSource.gallery);
    if (chatImage != null) {
      chatImage = XFile(chatImage!.path);
      print(chatImage!.path);
      emit(PickedImageSuccessState());
    } else {
      print('no image select');
      emit(PickedImageErrorState());
    }
  }

// /data/user/0/com.example.chat_app/cache/f3d994c4-d042-433f-b0bc-a39504204fb5/FB_IMG_1679519864824.jpg

  uploadImage({
    required name,
    required email,
    required phone,
    required bio,
  }) {
    emit(UploadImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(File(image!.path))
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadImageSuccessState());
        updateUser(
            name: name, email: email, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        emit(UploadImageErrorState());
      });
    }).catchError((error) {
      emit(UploadImageErrorState());
    });
  }

  void updateUser({
    required name,
    required email,
    required phone,
    required bio,
    String? image,
  }) {
    emit(UserUpdateLoadingState());

    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      uId: userModel!.uId,
      emailVerify: userModel!.emailVerify,
      image: image ?? userModel!.image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UserUpdateErrorState());
      print(error.toString());
    });
  }

  List<UserModel>? users;

  void getAllUsers() {
    emit(GetAllUserLoadingChatState());

    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel!.uId) {
          users!.add(UserModel.fromJson(element.data()));
        }
      });
      emit(GetAllUserSuccessChatState(userModel!));
    }).catchError((error) {
      emit(GetAllUserErrorChatState());
      print(error.toString());
    });
  }

  void sendMessage({
    String? receiveId,
    String? dateTime,
    String? text,
  }) {
    MessageModel model = MessageModel(
        senderId: userModel!.uId,
        dateTime: dateTime,
        text: text,
        receiveId: receiveId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiveId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessChatState());
    }).catchError((error) {
      emit(SendMessageErrorChatState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiveId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessChatState());
    }).catchError((error) {
      emit(SendMessageErrorChatState());
    });
  }

  List<MessageModel> messages = [];

  void getMessage({
    String? receiveId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiveId)
        .collection('message')
        .orderBy('dateTime',descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        return messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessChatState());
    });
  }
}
