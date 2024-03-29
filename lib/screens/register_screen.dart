import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../blocs/blocs.dart';
import '../data/data.dart';
import '../models/models.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginBlock = LoginBloc();
  final UserData user = UserData();

  @override
  Widget build(BuildContext scontext) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.red,
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset('images/logo_full.png'),
                      ),
                    ),
                    StreamBuilder<String>(
                      stream: _loginBlock.outName,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              hintText: "Nome Completo",
                              errorStyle: TextStyle(color: Colors.white),
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              icon: Icon(Icons.person_pin)),
                          keyboardType: TextInputType.text,
                          onSaved: (name) => user.name = name,
                          onChanged: _loginBlock.changeName,
                        );
                      },
                    ),
                    StreamBuilder<String>(
                      stream: _loginBlock.outEmail,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              errorStyle: TextStyle(color: Colors.white),
                              hintText: "Login",
                              icon: Icon(Icons.person_pin)),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email) {
                            user.email = email;
                          },
                          onChanged: _loginBlock.changeEmail,
                        );
                      },
                    ),
                    StreamBuilder<String>(
                      stream: _loginBlock.outPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              errorStyle: TextStyle(color: Colors.white),
                              hintText: "Senha",
                              icon: Icon(Icons.lock_outline)),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: _loginBlock.changePassword,
                          onSaved: (password) => user.password = password,
                        );
                      },
                    ),
                    StreamBuilder<String>(
                      stream: _loginBlock.outConfirmedPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              errorStyle: TextStyle(color: Colors.white),
                              hintText: "Confirmar Senha",
                              icon: Icon(Icons.lock_outline)),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: _loginBlock.changeConfirmedPassoword,
                          onSaved: (confirmPassword) =>
                              user.confirmPassword = confirmPassword,
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    StreamBuilder<bool>(
                      stream: _loginBlock.outSubmitValidRegister,
                      builder: (context, snapshot) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 50,
                            width: 145,
                            child: ElevatedButton(
                              child: ScopedModelDescendant<UserModel>(
                                builder: (context, child, model) {
                                  if (model.isLoading) {
                                    return Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Text(
                                      "Registrar",
                                      style: TextStyle(fontSize: 18),
                                    );
                                  }
                                },
                              ),
                              onPressed: snapshot.hasData
                                  ? () {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        if (user.password !=
                                            user.confirmPassword) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Senhas não coincidem!'),
                                            backgroundColor: Colors.red,
                                          ));
                                        } else {
                                          UserModel.of(context).signUp(
                                            user: user,
                                            onSuccess: _onSuccess,
                                            onFail: _onFail,
                                          );
                                        }
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Ou registre-se com:",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ElevatedButton(
                              onPressed: () async {
                                await UserModel.of(context).signUpWithGoogle(
                                    onSuccess: _onSuccess,
                                    onFail: _onFail,
                                    onFailGoogle: _onFailGoogle);
                              },
                              child: Container(
                                child: Image.asset(
                                  'images/google_signs_in.png',
                                  height: 50,
                                  width: 145,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ElevatedButton(
                              onPressed: () async {
                                await UserModel.of(context).signUpWithFacebook(
                                  onSuccess: _onSuccess,
                                  onFail: _onFail,
                                  onFailFacebook: _onFailFacebook,
                                );
                              },
                              child: Container(
                                child: Image.asset(
                                  'images/facebook_sign_in.png',
                                  height: 50,
                                  width: 145,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}

  void _onFailGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Esta conta Google já foi registrada",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }

  void _onFailFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Esta conta Facebook já foi registrada",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}
