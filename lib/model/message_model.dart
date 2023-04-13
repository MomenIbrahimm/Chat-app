class MessageModel{
  String? senderId;
  String? receiveId;
  String? dateTime;
  String? text;

  MessageModel({this.senderId,this.receiveId,this.dateTime,this.text});

  MessageModel.fromJson(Map<String,dynamic> json){
    senderId = json['senderId'];
    receiveId = json['receiveId'];
    dateTime = json['dateTime'];
    text = json['text'];

  }
  Map<String,dynamic> toMap(){
    return {
      'senderId' : senderId,
      'receiveId' : receiveId,
      'dateTime' : dateTime,
      'text' : text,
    };
  }
}