import 'package:bd_app_full/blocs/login_bloc.dart';
import 'package:bd_app_full/data/user_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserData user = UserData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.red[500],
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
                    Container(
                      margin: EdgeInsets.only(top: 100, bottom: 4),
                      child: StreamBuilder<String>(
                        stream: _loginBloc.outEmail,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                errorStyle: TextStyle(color: Colors.white),
                                hintText: "",
                                labelText: "Login",
                                icon: Icon(Icons.person_outline)),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) => user.email = email,
                            onChanged: _loginBloc.changeEmail,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: StreamBuilder<String>(
                        stream: _loginBloc.outPassword,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                errorStyle: TextStyle(color: Colors.white),
                                hintText: "",
                                labelText: 'Senha',
                                icon: Icon(Icons.lock_outline)),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (password) => user.password = password,
                            onChanged: _loginBloc.changePassword,
                          );
                        },
                      ),
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
                                padding: EdgeInsets.zero,
                                color: Colors.white,
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
                                        "Entrar",
                                        style: TextStyle(fontSize: 18),
                                      );
                                    }
                                  },
                                ),
                                textColor: Colors.red,
                                onPressed: snapshot.hasData
                                    ? () {
                                        UserModel.of(context).signIn(
                                          email: emailController.text,
                                          pass: passwordController.text,
                                          onFail: _onFail,
                                          onSuccess: _onSuccess,
                                        );
                                      }
                                    : null,
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
                              onPressed: () async {
                                UserModel.of(context).signInWithGoogle(
                                  onSuccess: _onSuccess,
                                  onFail: _onFailGoogle,
                                );
                              },
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
                                  borderRadius: new BorderRadius.circular(15)),
                              onPressed: () async {
                                UserModel.of(context).signInWithFacebook(
                                    onSuccess: _onSuccess,
                                    onFail: _onFailFacebook);
                              },
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
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSuccess() {}

  void _onFail() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Falha ao realizar login", textAlign: TextAlign.center),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFailGoogle() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Conta Google não registrada",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFailFacebook() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Conta Facebook não registrada",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
