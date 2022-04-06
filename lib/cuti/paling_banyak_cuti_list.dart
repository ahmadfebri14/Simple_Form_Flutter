import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:provider/provider.dart';

class PalingBanyakCutiList extends StatefulWidget {
  const PalingBanyakCutiList({Key? key}) : super(key: key);

  @override
  _PalingBanyakCutiListState createState() => _PalingBanyakCutiListState();
}

class _PalingBanyakCutiListState extends State<PalingBanyakCutiList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text("Leave More Than 1", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CutiModel>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.palingBanyakCuti.length,
                itemBuilder: (context, index) {
                  var palingBanyakCuti = state.palingBanyakCuti[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(palingBanyakCuti.nama),
                      trailing: Text(palingBanyakCuti.nomorInduk),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Leave Date: " + palingBanyakCuti.tanggalCuti),
                          Text("Description: " + palingBanyakCuti.keterangan),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.person),
                      ),
                    );
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
