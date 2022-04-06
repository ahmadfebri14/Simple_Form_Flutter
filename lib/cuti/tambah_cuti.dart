import 'package:flutter/material.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:mceasy_submission/karyawan_modul/karyawan_model.dart';
import 'package:mceasy_submission/model/cuti.dart';
import 'package:mceasy_submission/model/user.dart';
import 'package:provider/provider.dart';

DateTime _selectedDate = DateTime.now();
final _keteranganController = TextEditingController();
final _lamaCutiController = TextEditingController();
final _tglCutiController = TextEditingController();
final _noIndukController = TextEditingController();
final double _heightSpace = 15;

class CustomDialogCuti extends StatefulWidget {
  final String title;
  final Cuti cutiDetail;

  const CustomDialogCuti({
    Key? key,
    required this.title,
    required this.cutiDetail,
  }) : super(key: key);

  @override
  _CustomDialogCutiState createState() => _CustomDialogCutiState();
}

class _CustomDialogCutiState extends State<CustomDialogCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.title == "Create") {
      _noIndukController.text = "";
      _keteranganController.text = "";
      _tglCutiController.text =
          DateTime.now().toLocal().toString().split(' ')[0];
      _lamaCutiController.text = "";
    } else {
      _noIndukController.text = widget.cutiDetail.nomorInduk;
      _keteranganController.text = widget.cutiDetail.keterangan;
      _tglCutiController.text = widget.cutiDetail.tanggalCuti;
      _lamaCutiController.text = widget.cutiDetail.lamaCuti;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),
            Text(
              "${widget.title} Leave",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 1,
            ),
            Container(padding: EdgeInsets.all(15), child: formWidget(context))
          ],
        ),
      ),
    );
  }

  Form formWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _noIndukController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Registration Number',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder()),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Insert your registration number';
              }
              return null;
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          TextFormField(
            controller: _keteranganController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Description',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder()),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Insert description';
              }
              return null;
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _lamaCutiController,
            decoration: const InputDecoration(
                labelText: 'Leave Duration',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder()),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Insert your leave duration';
              }
              return null;
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          GestureDetector(
            child: TextFormField(
              enabled: false,
              controller: _tglCutiController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Leave Date',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder()),
            ),
            onTap: () async {
              await showDatePickerFunct(context);
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print(_keteranganController.text);

                if (widget.title == "Create") {
                  Cuti cuti = Cuti(
                      nomorInduk: _noIndukController.text,
                      keterangan: _keteranganController.text,
                      lamaCuti: _lamaCutiController.text,
                      tanggalCuti: _tglCutiController.text);

                  Provider.of<CutiModel>(context, listen: false).addCuti(cuti);
                } else {
                  Cuti cuti = Cuti(
                      id: widget.cutiDetail.id,
                      nomorInduk: _noIndukController.text,
                      keterangan: _keteranganController.text,
                      lamaCuti: _lamaCutiController.text,
                      tanggalCuti: _tglCutiController.text);

                  Provider.of<CutiModel>(context, listen: false)
                      .updateCuti(cuti);
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Data has been saved'),
                ));
              }
            },
            child: const Text("Submit"),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 60)),
          )
        ],
      ),
    );
  }

  Future<void> showDatePickerFunct(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2025, 12));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String tanggal = picked.toLocal().toString().split(' ')[0];
        _tglCutiController.text = tanggal;
      });
    }
  }
}
