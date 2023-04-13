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

