import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextInputType keyBoardType;
  final bool obscureText, borderEnabled;
  final double fontSize;
  final void Function(String text) onChanged;
  final String Function(String text) validator;

  const InputText(
      {Key key,
      this.label,
      this.keyBoardType = TextInputType.text,
      this.obscureText = false,
      this.borderEnabled = true,
      this.fontSize = 15.0,
      this.onChanged,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyBoardType,
      obscureText: this.obscureText,
      onChanged: this.onChanged,
      validator: this.validator,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        enabledBorder: this.borderEnabled
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                ),
              )
            : InputBorder.none,
        labelText: this.label,
        labelStyle: TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
