import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:mceasy_submission/cuti/tambah_cuti.dart';
import 'package:mceasy_submission/model/cuti.dart';
import 'package:provider/provider.dart';

class CutiList extends StatefulWidget {
  const CutiList({Key? key}) : super(key: key);

  @override
  _CutiListState createState() => _CutiListState();
}

class _CutiListState extends State<CutiList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Cuti cuti = Cuti(
              tanggalCuti: "",
              lamaCuti: "",
              keterangan: "",
              nomorInduk: ""
            );
            showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomDialogCuti(
                      title: "Create", cutiDetail: cuti,);
                });
          }),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text("Leave Report", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CutiModel>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.cuti.length,
                itemBuilder: (context, index) {
                  var cuti = state.cuti[index];
                  return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Provider.of<CutiModel>(context,
                                  listen: false)
                                  .deleteCuti(cuti.id!);

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
                                    return CustomDialogCuti(
                                        title: "Update", cutiDetail: cuti);
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
                        title: Text(cuti.nomorInduk),
                        trailing: Text(cuti.tanggalCuti),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: " + cuti.keterangan),
                            Text("Leave Duration: " + cuti.lamaCuti),
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
