import 'package:flutter/material.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/utils/responsive.dart';
import 'package:flutter_api_rest/widgets/input-text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = "", _password = "";

  _submit() {
    final bool formLoginIsValid = _formKey.currentState.validate();
    if (formLoginIsValid) {
      MyAPI.instance.login(context, email: _email, password: _password);
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
              SizedBox(height: responsive.diagonalPercent(1.8)),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InputText(
                        obscureText: true,
                        fontSize: responsive
                            .diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                        label: "Password",
                        borderEnabled: false,
                        onChanged: (text) {
                          this._password = text;
                        },
                        validator: (text) {
                          if (text.trim().length == 0) {
                            return "Invalid Password";
                          }
                          return null;
                        },
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.diagonalPercent(
                                responsive.isTablet ? 2.1 : 2.3)),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.diagonalPercent(2)),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Sign in',
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
                    'New to Friendly Desi?',
                    style: TextStyle(
                        fontSize: responsive
                            .diagonalPercent(responsive.isTablet ? 2.1 : 2.3)),
                  ),
                  FlatButton(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: responsive
                            .diagonalPercent(responsive.isTablet ? 2.1 : 2.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                  ),
                ],
              ),
              SizedBox(height: responsive.diagonalPercent(10)),
            ],
          ),
        ),
      ),
    );
  }
}
