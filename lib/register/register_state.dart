abstract class ChatRegisterState{}

class InitialChatState extends ChatRegisterState{}

class RegisterLoadingState extends ChatRegisterState{}
class RegisterSuccessState extends ChatRegisterState{}
class RegisterErrorState extends ChatRegisterState{
  final String error;

  RegisterErrorState(this.error);
}

class CreateUsersLoadingState extends ChatRegisterState{}

class CreateUsersSuccessState extends ChatRegisterState{}

class CreateUsersErrorState extends ChatRegisterState{
  final error;
  CreateUsersErrorState(this.error);
}