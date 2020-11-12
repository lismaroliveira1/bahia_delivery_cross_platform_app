import 'package:bahia_delivery/data/incremental_optional_data.dart';

class IncrementalOnlyChooseData {
  String id;
  String secao;
  List<IncrementalOptData> itens = [];

  IncrementalOnlyChooseData.getAll(
    String docId,
    String docSecao,
    List docItens,
  ) {
    id = docId;
    secao = docSecao;
    itens = docItens;
    print(id);
  }
}
