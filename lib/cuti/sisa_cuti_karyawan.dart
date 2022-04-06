import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mceasy_submission/cuti/cuti_model.dart';
import 'package:provider/provider.dart';

class SisaCutiList extends StatefulWidget {
  const SisaCutiList({Key? key}) : super(key: key);

  @override
  _SisaCutiListState createState() => _SisaCutiListState();
}

class _SisaCutiListState extends State<SisaCutiList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text("Leave Quota Report", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CutiModel>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.sisaCuti.length,
                itemBuilder: (context, index) {
                  var sisaCuti = state.sisaCuti[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(sisaCuti.nama),
                    subtitle: Text(sisaCuti.lamaCuti == null? "Leave Quota: 12" : "Leave Quota: " + (12 - int.parse(sisaCuti.lamaCuti)).toString()),
                    trailing: Text(sisaCuti.nomorInduk),
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
