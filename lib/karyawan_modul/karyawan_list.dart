import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mceasy_submission/karyawan_modul/tambah_karyawan.dart';
import 'package:mceasy_submission/model/user.dart';
import 'package:provider/provider.dart';

import 'karyawan_model.dart';

class KaryawanList extends StatefulWidget {
  const KaryawanList({Key? key}) : super(key: key);

  @override
  _KaryawanListState createState() => _KaryawanListState();
}

class _KaryawanListState extends State<KaryawanList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            User user = User(
                nomorInduk: "",
                tanggalBergabung: "",
                tanggalLahir: "",
                alamat: "",
                nama: "");
            showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomDialogEmployee(
                      title: "Create", userDetail: user);
                });
          }),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text("Employee Report", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.sort_by_alpha, color: Colors.blue,),
            ),
            onTap: () {
              print("sort");
              Provider.of<EmployeeModel>(context, listen: false).sortList();
            },
          ),
        ],
      ),
      body: Consumer<EmployeeModel>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
              reverse: state.reserve,
                shrinkWrap: true,
                itemCount: state.user.length,
                itemBuilder: (context, index) {
                  var user = state.user[index];
                  return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Provider.of<EmployeeModel>(context,
                                  listen: false)
                                  .deleteUser(user.id!);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Data has been deleted'),
                              ));
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                  barrierColor: Colors.black26,
                                  context: context,
                                  builder: (context) {
                                    return CustomDialogEmployee(
                                        title: "Update", userDetail: user);
                                  });
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.zoom_in,
                            label: 'Detail',
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(user.nama),
                        trailing: Text(user.nomorInduk),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Address: " + user.alamat),
                            Text("Birth Date: " + user.tanggalLahir),
                            Text("Joined Date: " + user.tanggalBergabung),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                      ));
                });
          } else if (state.state == ResultState.NoData) {
            return Center(child: Text(state.message));
          } else if (state.state == ResultState.Error) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text(''));
          }
        },
      ),
    );
  }
}
