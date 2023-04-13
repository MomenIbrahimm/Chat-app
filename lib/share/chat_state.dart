import 'package:chat_app/model/user_model.dart';

abstract class ChatState{}

class InitialChatState extends ChatState{}

class GetUserLoadingChatState extends ChatState{}
class GetUserSuccessChatState extends ChatState{}
class GetUserErrorChatState extends ChatState{}

class PickedImageSuccessState extends ChatState{}
class PickedImageErrorState extends ChatState{}

class UploadImageLoadingState extends ChatState{}
class UploadImageSuccessState extends ChatState{}
class UploadImageErrorState extends ChatState{}

class UserUpdateLoadingState extends ChatState{}
class UserUpdateErrorState extends ChatState{}

class GetAllUserLoadingChatState extends ChatState{}
class GetAllUserSuccessChatState extends ChatState{
  UserModel model;
  GetAllUserSuccessChatState(this.model);
}
class GetAllUserErrorChatState extends ChatState{}

class SendMessageSuccessChatState extends ChatState{}
class SendMessageErrorChatState extends ChatState{}

class GetMessageSuccessChatState extends ChatState{}
class GetMessageErrorChatState extends ChatState{}

class ChangeSwitch extends ChatState{}




