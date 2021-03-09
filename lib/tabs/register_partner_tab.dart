import 'package:flutter/material.dart';

import '../components/components.dart';
import '../screens/screens.dart';

class RegisterPartnerTab extends StatefulWidget {
  @override
  _RegisterPartnerTabState createState() => _RegisterPartnerTabState();
}

class _RegisterPartnerTabState extends State<RegisterPartnerTab> {
  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width / 3;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: _imageSize,
                  width: _imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                        'images/logo_and_name.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  'Você é pessoa\nfísica ou jurídica?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () {
                        pageTransition(
                          context: context,
                          screen: new RegisterPartnerWithCPFScreen(),
                        );
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red),
                        child: Center(
                          child: Text(
                            "Sou pessoa física \n uso CPF",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        pageTransition(
                          context: context,
                          screen: new RegisterPartnerWithCNPJScreen(),
                        );
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red),
                        child: Center(
                          child: Text(
                            "Sou pessoa jurídica \n uso CNPJ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
