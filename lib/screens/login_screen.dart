import 'package:bahia_delivery/blocs/login_bloc.dart';
import 'package:bahia_delivery/models/user.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/register_screen.dart';
import 'package:bahia_delivery/widgets/imput_field.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red[500],
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset('images/logo_full.png'),
                        ),
                        InputField(
                          onSaved: null,
                          icon: Icons.person_outline,
                          hint: "Login",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        InputField(
                          onSaved: (password) => user.password = password,
                          icon: Icons.lock_outline,
                          hint: 'Senha',
                          obscure: true,
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 50,
                                  width: 145,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    child: Text(
                                      "Entrar",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    textColor: Colors.red,
                                    onPressed: snapshot.hasData ? () {} : null,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Ou entre com:",
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
                                child: RaisedButton(
                                  onPressed: () {},
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.zero,
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
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15)),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Não tem conta ainda?",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            FlatButton(
                              child: Text(
                                "Registre-se",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
