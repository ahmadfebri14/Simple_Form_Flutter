import 'package:flutter/material.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:mceasy_submission/model/user.dart';
import 'package:provider/provider.dart';
import 'karyawan_model.dart';

DateTime _selectedDate = DateTime.now();
final _nameController = TextEditingController();
final _birthController = TextEditingController();
final _addressController = TextEditingController();
final _tglBergabungController = TextEditingController();
final _noIndukController = TextEditingController();
final double _heightSpace = 15;

// class TambahKaryawan extends StatefulWidget {
//   const TambahKaryawan({Key? key}) : super(key: key);
//
//   @override
//   State<TambahKaryawan> createState() => _AddEmployeePageState();
// }
//
// class _AddEmployeePageState extends State<TambahKaryawan> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     _birthController.text = DateTime.now().toLocal().toString().split(' ')[0];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Center(
//               child: Text(
//                 "Data Karyawan",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//               )),
//           const SizedBox(
//             height: 60,
//           ),
//           // formWidget(context)
//         ],
//       ),
//     );
//   }
// }


class CustomDialogEmployee extends StatefulWidget {
  final String title;
  final User userDetail;

  const CustomDialogEmployee({
    Key? key,
    required this.title,
    required this.userDetail,
  }) : super(key: key);

  @override
  _CustomDialogEmployeeState createState() => _CustomDialogEmployeeState();
}

class _CustomDialogEmployeeState extends State<CustomDialogEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.title == "Create") {
      _noIndukController.text = "";
      _nameController.text = "";
      _addressController.text = "";
      _birthController.text = DateTime.now().toLocal().toString().split(' ')[0];
      _tglBergabungController.text = DateTime.now().toLocal().toString().split(' ')[0];
    } else {
      _noIndukController.text = widget.userDetail.nomorInduk;
      _nameController.text = widget.userDetail.nama;
      _addressController.text = widget.userDetail.alamat;
      _birthController.text = widget.userDetail.tanggalLahir;
      _tglBergabungController.text = widget.userDetail.tanggalBergabung;
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
              "${widget.title} Employee",
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
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Name',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder()),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Insert your Name';
              }
              return null;
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          TextFormField(
            controller: _addressController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Address',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder()),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Insert your address';
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
              controller: _birthController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Birth Date',
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
          GestureDetector(
            child: TextFormField(
              enabled: false,
              controller: _tglBergabungController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Joined Date',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder()),
            ),
            onTap: () async {
              await showDatePickerFunct2(context);
            },
          ),
          SizedBox(
            height: _heightSpace,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print(_nameController.text);

                if(widget.title == "Create") {
                  User user1 = User(
                      nomorInduk: _noIndukController.text,
                      nama: _nameController.text,
                      alamat: _addressController.text,
                      tanggalBergabung: _tglBergabungController.text,
                      tanggalLahir: _birthController.text);

                  Provider.of<EmployeeModel>(context, listen: false)
                      .addUser(user1);
                  // Provider.of<CutiModel>(context, listen: false)
                  //     .fetchRecent();
                } else {
                  int id = 0;
                  id = (widget.userDetail.id != null? widget.userDetail.id : 0)!;
                  User user1 = User(
                      id: widget.userDetail.id,
                      nomorInduk: _noIndukController.text,
                      nama: _nameController.text,
                      alamat: _addressController.text,
                      tanggalBergabung: _tglBergabungController.text,
                      tanggalLahir: _birthController.text);

                  Provider.of<EmployeeModel>(context, listen: false)
                      .updateUser(user1, id);
                  // Provider.of<CutiModel>(context, listen: false)
                  //     .fetchRecent();
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
        _birthController.text = tanggal;
      });
    }
  }

  Future<void> showDatePickerFunct2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2025, 12));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String tanggal = picked.toLocal().toString().split(' ')[0];
        _tglBergabungController.text = tanggal;
      });
    }
  }
}