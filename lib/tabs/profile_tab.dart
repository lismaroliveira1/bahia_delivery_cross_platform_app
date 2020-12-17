import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/be_a_partner_screen.dart';
import 'package:bd_app_full/screens/coupon_screen.dart';
import 'package:bd_app_full/screens/notifications_screen.dart';
import 'package:bd_app_full/screens/order_user_screen.dart';
import 'package:bd_app_full/screens/payment_user_screen.dart';
import 'package:bd_app_full/screens/setup_user_screen.dart';
import 'package:bd_app_full/screens/store_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxScrolled,
        ) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PaymentUserScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.message,
                      ),
                      title: Text(
                        "Pagamentos",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Minhas formas de pagamento",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CouponScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.payment,
                      ),
                      title: Text(
                        "Cupons",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Meus Cupons",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(UserModel.of(context).firebaseUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String title;
                        String subtitle;
                        int status = snapshot.data.get("isPartner");
                        switch (status) {
                          case 1:
                            title = "Gerencie Sua loja";
                            subtitle =
                                "Venda seus produtos através do Bahia Delivery";
                            break;
                          case 2:
                            title = "Proposta enviada";
                            subtitle = "Analisando seus dados";
                            break;
                          case 3:
                            title = "Seja nosso parceiro";
                            subtitle =
                                "Venda seus produtos através do Bahia Delivery";
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 6,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey[400],
                                )),
                            child: ListTile(
                              dense: true,
                              onTap: () {
                                if (status == 1) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: StoreHomeScrenn(),
                                      inheritTheme: true,
                                      duration: Duration(
                                        milliseconds: 350,
                                      ),
                                      ctx: context,
                                    ),
                                  );
                                } else if (status == 3) {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.white),
                                              height: 400,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.red[50]),
                                                    height: 150,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      child: Center(
                                                        child: Image.asset(
                                                            "images/logo.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Text(
                                                          "Bem vindo ao Bahia Delivery Partners",
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Algumas informações a mais serão requeridas.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 60,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Container(
                                                            height: 50,
                                                            width: 140,
                                                            child: RaisedButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: Colors.red,
                                                              child: Text(
                                                                "Voltar",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              disabledColor:
                                                                  Colors.grey,
                                                              disabledTextColor:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child: Container(
                                                              height: 50,
                                                              width: 140,
                                                              child:
                                                                  RaisedButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                color:
                                                                    Colors.red,
                                                                child: Text(
                                                                  "Ok, vamos lá!",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(
                                                                          MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            BeAPartnerScreen(),
                                                                  ));
                                                                },
                                                                disabledColor:
                                                                    Colors.grey,
                                                                disabledTextColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        );
                                      });
                                }
                              },
                              leading: Icon(
                                Icons.scatter_plot,
                              ),
                              title: Text(title),
                              subtitle: Text(
                                subtitle,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NotificationSetupScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(Icons.notifications_active),
                      title: Text(
                        "Seja um entregador",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Trabalhe conosco entregando mercadorias",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NotificationSetupScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(Icons.notifications_active),
                      title: Text(
                        "Notificações",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Gerencie as suas notificações",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: OrderUserScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.list,
                      ),
                      title: Text(
                        "Pedidos",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Acompanhe seus pedidos",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400],
                        )),
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SetupUserScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.phonelink_setup,
                      ),
                      title: Text(
                        "Configurações",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        "Configure o apicativo do seu jeito",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
