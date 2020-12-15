import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisterPartnerWithCPFTab extends StatefulWidget {
  @override
  _RegisterPartnerWithCPFTabState createState() =>
      _RegisterPartnerWithCPFTabState();
}

class _RegisterPartnerWithCPFTabState extends State<RegisterPartnerWithCPFTab> {
  TextEditingController _nameController = TextEditingController();
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;
  @override
  void initState() {
    _selectedDate = '';
    _dateCount = '';
    _range = '';
    _rangeCount = '';
    super.initState();
  }

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
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  'Deixe-nos saber \n mais sobre você',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Fulano de tal",
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                      child: FlatButton(
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (_) => Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          color: Colors.white,
                        ),
                      );
                    },
                    child: Text(
                      '__/__/_____',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black38,
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
}
