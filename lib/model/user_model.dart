class UserModel{
  String? email;
  String? name;
  String? phone;
  String? uId;
  String? image;
  String? bio;
  bool? emailVerify;

  UserModel({this.email,this.name,this.phone,this.uId,this.image,this.bio,this.emailVerify});

  UserModel.fromJson(Map<String,dynamic> json){
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    bio = json['bio'];
    emailVerify = json['isEmailVerify'];
    image = json['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'email' : email,
      'name' : name,
      'phone' : phone,
      'uId' : uId,
      'isEmailVerify' : emailVerify,
      'image' : image,
      'bio' : bio,
    };
  }
}