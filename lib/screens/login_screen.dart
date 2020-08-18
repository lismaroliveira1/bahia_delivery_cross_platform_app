import 'package:bahia_delivery/widgets/imput_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
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
                      icon: Icons.person_outline,
                      hint: "Login",
                      obscure: false),
                  InputField(
                    icon: Icons.lock_outline,
                    hint: 'Senha',
                    obscure: true,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 50,
                    width: 145,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.red,
                      onPressed: () {},
                    ),
                  ),
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
                        RaisedButton(
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
                        Spacer(),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15)),
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
                        onPressed: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
