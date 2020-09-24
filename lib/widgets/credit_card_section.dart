import 'package:bahia_delivery/blocs/credit_card_bloc.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/card_back.dart';
import 'package:bahia_delivery/widgets/card_front.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreditCardSession extends StatefulWidget {
  @override
  _CreditCardSessionState createState() => _CreditCardSessionState();
}

class _CreditCardSessionState extends State<CreditCardSession> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final _creditCardBloc = CreditCardBloc();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SafeArea(
                child: FlipCard(
                  key: cardKey,
                  direction: FlipDirection.HORIZONTAL,
                  speed: 700,
                  front: CardFront(),
                  back: CardBack(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () => cardKey.currentState.toggleCard(),
                child: Container(
                  height: 30,
                  child: Image.asset("images/icon_spin.png"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: StreamBuilder<Object>(
                    stream: _creditCardBloc.outCardNumber,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: _creditCardBloc.changeCardNumber,
                        decoration: InputDecoration(
                          labelText: "Número do Cartão",
                          hintText: "0000-0000-0000-0000",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: OutlineInputBorder(),
                        ),
                      );
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: StreamBuilder<Object>(
                    stream: _creditCardBloc.outOwnerName,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: _creditCardBloc.changeOwnerName,
                        decoration: InputDecoration(
                          labelText: "Nome",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          hintText: "Nome escrito no cartão",
                          border: OutlineInputBorder(),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: StreamBuilder<Object>(
                          stream: _creditCardBloc.outValidateDateCard,
                          builder: (context, snapshot) {
                            return TextField(
                              onChanged: _creditCardBloc.changeValidadeDateCard,
                              decoration: InputDecoration(
                                  labelText: "Validade",
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  hintText: "MM/AAAA",
                                  border: OutlineInputBorder()),
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: StreamBuilder<Object>(
                          stream: _creditCardBloc.outCVV,
                          builder: (context, snapshot) {
                            return TextField(
                              onChanged: _creditCardBloc.changeCVV,
                              decoration: InputDecoration(
                                  labelText: "CVV",
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  hintText: "123",
                                  border: OutlineInputBorder()),
                            );
                          }),
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
                        onChanged: _creditCardBloc.changeCPF,
                        decoration: InputDecoration(
                            labelText: "CPF",
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            hintText: "000.000.000-00",
                            border: OutlineInputBorder()),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
