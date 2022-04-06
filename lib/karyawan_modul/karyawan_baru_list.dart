import 'package:flutter/material.dart';
import 'package:mceasy_submission/karyawan_modul/karyawan_model.dart';
import 'package:provider/provider.dart';

class KaryawanBaruList extends StatefulWidget {
  const KaryawanBaruList({Key? key}) : super(key: key);

  @override
  _KaryawanBaruListState createState() => _KaryawanBaruListState();
}

class _KaryawanBaruListState extends State<KaryawanBaruList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeModel>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          // Provider.of<EmployeeModel>(context).fetchRecent();
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.recentUser.length,
              itemBuilder: (context, index) {
                var recentUser = state.recentUser[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(recentUser.nama),
                  trailing: Text(recentUser.nomorInduk),
                  subtitle: Text("Joined Date: " + recentUser.tanggalBergabung),
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
    );
  }
}
