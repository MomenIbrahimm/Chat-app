abstract class ChatLoginState{}

class InitialLoginState extends ChatLoginState{}

class ShowPassState extends ChatLoginState{}

class ChatLoginLoadingState extends ChatLoginState{}
class ChatLoginSuccessState extends ChatLoginState{
  String uId;
  ChatLoginSuccessState(this.uId);
}
class ChatLoginErrorState extends ChatLoginState{
  final String error;
  ChatLoginErrorState(this.error);

}

class ChatLoginWithGoogleLoadingState extends ChatLoginState{}

class CreateUsersSuccessState extends ChatLoginState{}
class CreateUsersErrorState extends ChatLoginState{}

class ChatLoginWithGoogleSuccessState extends ChatLoginState{
  String uId;
  ChatLoginWithGoogleSuccessState(this.uId);
}
class ChatLoginWithGoogleErrorState extends ChatLoginState{
  final String error;
  ChatLoginWithGoogleErrorState(this.error);

}

class CreateUsersLoadingState extends ChatLoginState{}
class CreateUsersWithGoogleSuccessState extends ChatLoginState{}
class CreateUsersWithGoogleErrorState extends ChatLoginState{
  final error;
  CreateUsersWithGoogleErrorState(this.error);
}

