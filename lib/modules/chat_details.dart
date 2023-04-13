import 'package:buildcondition/buildcondition.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/share/chat_cubit.dart';
import 'package:chat_app/share/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../share/components.dart';

class ChatDetails extends StatelessWidget {
  ChatDetails({Key? key, this.model}) : super(key: key);

  var typController = TextEditingController();
  final controller = ScrollController();
  UserModel? model;

  @override
  Widget build(BuildContext context) {
    return Builder(
       builder: (BuildContext context) {
        ChatCubit.get(context).getMessage(receiveId: model!.uId);
        return BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${model!.image}'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '${model!.name}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    requestFocus(context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image.jpg'), fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
                      child: Column(
                        children: [
                          BuildCondition(
                            condition: ChatCubit.get(context).messages.isNotEmpty,
                            builder: (context)=> Expanded(
                              child: ListView.separated(
                                reverse: true,
                                controller: controller,
                                itemBuilder: (context,index){
                                  var message = ChatCubit.get(context).messages[index];
                                  if(ChatCubit.get(context).userModel!.uId == message.senderId)
                                  {
                                    return myBuildMessage(message);
                                  }else{
                                    return buildMessage(message);
                                  }
                                },
                                separatorBuilder: (context,index)=>const SizedBox(height: 5.0,),
                                itemCount:  ChatCubit.get(context).messages.length,
                              ),
                            ),
                            fallback: (context)=> const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Start chat with your friend',style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                            ),
                          ),
                          if(ChatCubit.get(context).messages.isEmpty)
                            const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: SizedBox(
                              height: 50.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: typController,
                                      style: const TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(25.0)),
                                          hintText: 'Message',
                                          suffixIcon: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white30,
                                          hintStyle: const TextStyle(
                                              fontSize: 14.0, color: Colors.grey),
                                          iconColor: Theme.of(context).primaryColor),
                                      onFieldSubmitted: (value) {},
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {
                                          ChatCubit.get(context).sendMessage(
                                              receiveId: model!.uId,
                                              text: typController.text,
                                              dateTime: (DateTime.now()).toString());
                                          typController.clear();
                                          controller.animateTo(
                                            0.0,
                                            duration: const Duration(microseconds:1),
                                            curve: Curves.fastOutSlowIn,
                                          );

                                        },
                                        icon: (const Icon(Icons.send, color: Colors.white)),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          },
        );
       },
    );
  }

  buildMessage(MessageModel messageModel){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  messageModel.text!,
                  style:
                  const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 2.0,),
                Text(DateFormat.jm().format(DateTime.now()),style: const TextStyle(color: Colors.white54,fontSize: 8.0),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  myBuildMessage(MessageModel messageModel){
    return  Padding(
      padding: const EdgeInsets.only(right: 16.0,left: 60.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent[400],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  messageModel.text!,
                  style:
                  const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 2.0,),
                Text(DateFormat.jm().format(DateTime.now()),style: TextStyle(color: Colors.white54,fontSize: 8.0),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
