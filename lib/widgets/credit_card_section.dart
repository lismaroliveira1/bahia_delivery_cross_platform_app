import 'package:bahia_delivery/blocs/credit_card_bloc.dart';
import 'package:bahia_delivery/data/credit_debit_card_item.dart';
import 'package:bahia_delivery/input_formaters/cpf_input_formaters.dart';
import 'package:bahia_delivery/input_formaters/upper_case_input_formater.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/tiles/credit_card_imput_formater.dart';
import 'package:bahia_delivery/widgets/card_back.dart';
import 'package:bahia_delivery/widgets/card_front.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class CreditCardSession extends StatefulWidget {
  @override
  _CreditCardSessionState createState() => _CreditCardSessionState();
}

class _CreditCardSessionState extends State<CreditCardSession> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String cardNumber = '';
  String cardOwnerName = '';
  String cardValidateDate = '';
  String cardCVV = '';
  String asset = 'images/transparent.png';
  String cpf = '';
  String brand;
  final _creditCardBloc = CreditCardBloc();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: FlipCard(
                    key: cardKey,
                    direction: FlipDirection.HORIZONTAL,
                    speed: 700,
                    front: CardFront(
                        cardNumber: cardNumber,
                        cardOwnerName: cardOwnerName,
                        cardValidateDate: cardValidateDate,
                        cardCVV: cardCVV,
                        cpf: cpf,
                        asset: asset),
                    back: CardBack(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () => cardKey.currentState.toggleCard(),
                      child: Container(
                        height: 30,
                        child: Image.asset("images/icon_spin.png"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: StreamBuilder<Object>(
                    stream: _creditCardBloc.outCardNumber,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: (value) {
                          _creditCardBloc.changeCardNumber(value);
                          if (!cardKey.currentState.isFront)
                            cardKey.currentState.toggleCard();
                          setState(
                            () {
                              cardNumber = value;
                              var valueFormated =
                                  detectCCType(value.replaceAll(" ", ""));
                              if (value == null ||
                                  value == '' ||
                                  valueFormated == CreditCardType.unknown) {
                                asset = 'images/transparent.png';
                              } else if (valueFormated == CreditCardType.visa) {
                                asset = 'images/visa_logo.png';
                                brand = 'visa';
                              } else if (valueFormated ==
                                  CreditCardType.mastercard) {
                                asset = 'images/mastercard_logo.png';
                                brand = 'mastercard';
                              } else if (valueFormated ==
                                  CreditCardType.dinersclub) {
                                asset = 'images/dinnersclub_logo.png';
                                brand = 'dinersclub';
                              } else if (valueFormated == CreditCardType.amex) {
                                asset = 'images/americam_express_logo.png';
                                brand = 'americamexpress';
                              } else if (valueFormated ==
                                  CreditCardType.discover) {
                                asset = 'images/discover_logo.png';
                                brand = 'discover';
                              } else if (valueFormated == CreditCardType.jcb) {
                                asset = 'images/jcb_logo.png';
                                brand = 'jcb';
                              } else if (valueFormated ==
                                  CreditCardType.unionpay) {
                                asset = 'images/unionpay_logo.png';
                                brand = 'unionpay';
                              } else if (valueFormated ==
                                  CreditCardType.maestro) {
                                asset = 'images/maestro_logo.png';
                                brand = 'maestro';
                              } else if (valueFormated == CreditCardType.mir) {
                                asset = 'images/mir_logo.png';
                                brand = 'mir';
                              } else if (valueFormated ==
                                  CreditCardType.hipercard) {
                                asset = 'images/hipercard_logo.png';
                                brand = 'hipercard';
                              } else if (valueFormated == CreditCardType.elo) {
                                asset = 'images/elo_logo.png';
                                brand = 'elo';
                              } else {
                                asset = 'images/transparent.png';
                                brand = '';
                              } //TODO implementar as decisões para as bandeiras aura e discovery
                            },
                          );
                        },
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Número do Cartão",
                          hintText: "0000 0000 0000 0000",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          MaskedTextInputFormatter(
                              mask: 'xxxx xxxx xxxx xxxx', separator: ' ')
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: StreamBuilder<Object>(
                    stream: _creditCardBloc.outOwnerName,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: (value) {
                          _creditCardBloc.changeOwnerName(value);
                          if (!cardKey.currentState.isFront)
                            cardKey.currentState.toggleCard();
                          setState(
                            () {
                              cardOwnerName = value;
                            },
                          );
                        },
                        decoration: InputDecoration(
                          labelText: "Nome",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          hintText: "Nome escrito no cartão",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [UpperCaseTextFormatter()],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: StreamBuilder<Object>(
                          stream: _creditCardBloc.outValidateDateCard,
                          builder: (context, snapshot) {
                            return TextField(
                              autocorrect: false,
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _creditCardBloc.changeValidadeDateCard(value);
                                if (!cardKey.currentState.isFront)
                                  cardKey.currentState.toggleCard();
                                setState(() {
                                  cardValidateDate = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Validade",
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                hintText: "MM/AAAA",
                                border: OutlineInputBorder(),
                              ),
                              inputFormatters: [
                                MaskedTextInputFormatter(
                                    mask: 'xx/xxxx', separator: '/')
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: StreamBuilder<Object>(
                          stream: _creditCardBloc.outCVV,
                          builder: (context, snapshot) {
                            return TextField(
                              onChanged: (value) {
                                _creditCardBloc.changeCVV(value);
                                if (cardKey.currentState.isFront)
                                  cardKey.currentState.toggleCard();
                                setState(
                                  () {
                                    cardCVV = value;
                                  },
                                );
                              },
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: "CVV",
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                hintText: "123",
                                border: OutlineInputBorder(),
                              ),
                              inputFormatters: [],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: StreamBuilder<Object>(
                    stream: _creditCardBloc.outCPF,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: (value) {
                          _creditCardBloc.changeCPF(value);
                          if (!cardKey.currentState.isFront)
                            cardKey.currentState.toggleCard();
                          cpf = value;
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        maxLength: 14,
                        decoration: InputDecoration(
                          labelText: "CPF",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          hintText: "000.000.000-00",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [CPFTextFormatter()],
                      );
                    },
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    final creditDebitCard = CreditDebitCard(
                        cardNumber: cardNumber,
                        cardOwnerName: cardOwnerName,
                        validateDate: cardValidateDate,
                        cpf: cpf,
                        cvv: cardCVV,
                        image: asset,
                        brand: brand);
                    model.newCard(creditDebitCard);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
