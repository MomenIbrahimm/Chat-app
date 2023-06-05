import 'package:flutter/material.dart';

Widget defaultMaterialButton({
  context,
  required Function onPressed,
  required String text,
  double high = 40,
  double width = 150,
  Color color1 = Colors.blueAccent,
  Color color2 = Colors.lightBlueAccent,
  Color textColor = Colors.white,
  bool isUpperCase = false,
}) {
  return Center(
    child: Container(
      width: width,
      height: high,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[color1, color2]),
      ),
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ),
    ),
  );
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyBoardTyp,
  required context,
  required String text,
  Icon? prefixIcon,
  required Function onSubmitted,
  String? validateText,
  IconButton? suffixIcon,
  bool obscure = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyBoardTyp,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25.0)),
        hintText: text,
        filled: true,
        fillColor: Colors.black12,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        iconColor: Theme.of(context).primaryColor),
    onFieldSubmitted: (value) {
      onSubmitted;
    },
    validator: (value) {
      if (value!.isEmpty) {
        return validateText;
      }
      return null;
    },
  );
}

defaultText(
    {required String text,
    double size = 18.0,
    fontWeight,
    double letterSpacing = 0.0,
    Color color = Colors.black,
    isUpperCase = false}) {
  return Text(
    isUpperCase ? text.toUpperCase() : text,
    style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color),
  );
}

defaultTextButton(
    {required Function onPressed,
    required String text,
    fontWeight,
    double? size,
    bool isUpperCase = false}) {
  return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(fontWeight: fontWeight, fontSize: size)));
}

navigateTo(context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigateAndReplace(context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigateAndFinish(context, widget) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

errorSnackBar({context,text,Function? function}){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.red,
    action: SnackBarAction(label: 'Ops :(',textColor: Colors.white, onPressed: () {
      function!();
    }),
  ));
}


successSnackBar({context,text,Function? function}){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.green,
    action: SnackBarAction(label: 'Great!',textColor: Colors.white, onPressed: () {
      function!();
    }),
  ));
}

requestFocus(context){
  return FocusScope.of(context).requestFocus(FocusNode());

}
