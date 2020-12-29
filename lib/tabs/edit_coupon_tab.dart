import 'package:bd_app_full/data/coupon_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditCouponTab extends StatefulWidget {
  final CouponData couponData;
  EditCouponTab(this.couponData);
  @override
  _EditCouponTabState createState() => _EditCouponTabState();
}

class _EditCouponTabState extends State<EditCouponTab> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  PickerDateRange _selectedDate;
  String _textDate;
  bool isPeriodChoosed;

  @override
  void initState() {
    _selectedDate = PickerDateRange(
      widget.couponData.start,
      widget.couponData.end,
    );
    isPeriodChoosed = true;
    _textDate = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.black54,
              ),
              collapsedHeight: 200,
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'images/logo_and_name.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _titleController
                      ..text = widget.couponData.title,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Título',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _descriptionController
                      ..text = widget.couponData.description,
                    maxLines: 2,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        isPeriodChoosed = false;
                      });
                      onPeriodButtonPressed();
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          'Período',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                isPeriodChoosed
                    ? Center(
                        child: Column(
                        children: [
                          Text(
                              "Início ${_selectedDate.startDate.day}/${_selectedDate.startDate.month}/${_selectedDate.startDate.year}"),
                          Text(
                              "Fim ${_selectedDate.endDate.day}/${_selectedDate.endDate.month}/${_selectedDate.endDate.year}"),
                        ],
                      ))
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 150,
                  ),
                  child: Container(
                    width: 80,
                    child: TextField(
                      controller: _discountController
                        ..text = widget.couponData.discount.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Desconto',
                        hintText: '%',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: FlatButton(
                    onPressed: () {
                      if (isPeriodChoosed) {
                        final couponData = CouponData(
                          id: widget.couponData.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          message: _messageController.text,
                          discount: int.parse(
                            _discountController.text,
                          ),
                          start: _selectedDate.startDate,
                          end: _selectedDate.endDate,
                        );
                        UserModel.of(context).editCouponData(
                          couponData: couponData,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                        Navigator.of(context).pop();
                      } else {
                        noPeriodConfigured();
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "Enviar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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

  Future<dynamic> onPeriodButtonPressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Selecione o período de\nvigência do cupom",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red),
                          child: Center(
                            child: Text(
                              "Cancelar",
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
                          if (isPeriodChoosed) {
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Selecione a data final",
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red),
                          child: Center(
                            child: Text(
                              "Ok",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = args.value;
    setState(() {
      _textDate = _selectedDate.startDate.day.toString() +
          '/' +
          _selectedDate.startDate.month.toString() +
          '/' +
          _selectedDate.startDate.year.toString();
    });
    if (_selectedDate.endDate != null) {
      setState(() {
        _selectedDate = args.value;
        isPeriodChoosed = true;
      });
    }
  }

  void _onSuccess() {}
  void _onFail() {}
  void noPeriodConfigured() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "É Necessário definir o período de vigência do cupom",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
