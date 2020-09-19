import 'package:flutter/material.dart';
import 'package:flutter_api_rest/utils/responsive.dart';
import 'package:flutter_api_rest/widgets/input-text.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = "", _password = "", _username = "";

  _submit() {
    final bool formLoginIsValid = _formKey.currentState.validate();
    if (formLoginIsValid) {
      print(this._email);
      print(this._password);
      print(this._username);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.isTablet ? 430 : 330,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputText(
                fontSize:
                    responsive.diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                label: "Username",
                onChanged: (text) {
                  this._username = text;
                },
                validator: (text) {
                  if (text.trim().length < 6) {
                    return "Invalid Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: responsive.diagonalPercent(1.8)),
              InputText(
                fontSize:
                    responsive.diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                keyBoardType: TextInputType.emailAddress,
                label: "E-mail Address",
                onChanged: (text) {
                  this._email = text;
                },
                validator: (text) {
                  if (!text.contains("@")) {
                    return "Invalid Email";
                  }
                  return null;
                },
              ),
              InputText(
                fontSize:
                    responsive.diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                keyBoardType: TextInputType.emailAddress,
                label: "Password",
                onChanged: (text) {
                  this._password = text;
                },
                validator: (text) {
                  if (text.trim().length < 6) {
                    return "Invalid Password";
                  }
                  return null;
                },
              ),
              SizedBox(height: responsive.diagonalPercent(2)),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive
                          .diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                    ),
                  ),
                  onPressed: this._submit,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(
                  height: responsive
                      .diagonalPercent(responsive.isTablet ? 2.1 : 2.3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        fontSize: responsive
                            .diagonalPercent(responsive.isTablet ? 2.1 : 2.3)),
                  ),
                  FlatButton(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: responsive
                            .diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: responsive.diagonalPercent(1)),
            ],
          ),
        ),
      ),
    );
  }
}
