import 'package:flutter/cupertino.dart';
import 'package:mceasy_submission/model/cuti.dart';
import 'package:mceasy_submission/model/paling_banyak_cuti.dart';
import 'package:mceasy_submission/model/sisa_cuti.dart';

import '../database_handler.dart';

enum ResultState { Loading, NoData, HasData, Error }

class CutiModel extends ChangeNotifier {
  final handler = DatabaseHandler();
  late ResultState _state;
  String _message = '';

  List<Cuti> _cuti = [];
  List<Cuti> get cuti => _cuti;

  List<SisaCuti> _sisaCuti = [];
  List<SisaCuti> get sisaCuti => _sisaCuti;

  List<PalingBanyakCuti> _palingBanyakCuti = [];
  List<PalingBanyakCuti> get palingBanyakCuti => _palingBanyakCuti;

  ResultState get state => _state;
  String get message => _message;

  CutiModel(){
    print("init");
    handler.initializeDB();
    fetchAll();
    // fetchTop();
    fetchPalingBanyakCuti();
    fetchRecent();
  }

  Future<void> fetchTop() async {
    final map = handler.getSisaCutiKaryawan();
    map.then((value) => {
      value.forEach((element) {
        // print(element["nomorInduk"].toString());
        SisaCuti cuti = SisaCuti(
            element["nomorInduk"].toString(),
            element["nama"].toString(),
            element["lamacuti"].toString()
        );
        _sisaCuti.add(cuti);
        print(element.toString());
      })
    });
    notifyListeners();
  }

  Future<void> addCuti(Cuti cuti) async {
    List<Cuti> listOfCuti = [cuti];
    await handler.insertCuti(listOfCuti);

    // getUser();
    // fetchAll();
    fetchAll();
    fetchRecent();
    // fetchTop();
    fetchPalingBanyakCuti();
  }

  Future<void> updateCuti(Cuti cuti) async {
    await handler.updateCuti(cuti);

    // fetchAll();
    fetchAll();
    fetchRecent();
    // fetchTop();
    fetchPalingBanyakCuti();
  }

  Future<void> deleteCuti(int id) async {
    await handler.deleteCuti(id);

    // fetchAll();
    fetchAll();
    fetchRecent();
    // fetchTop();
    fetchPalingBanyakCuti();
  }

  Future<dynamic> fetchAll() async {
    print("ini2");
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final cuti = await handler.retrieveCuti();
      if(cuti.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else {
        _state = ResultState.HasData;
        notifyListeners();
        return _cuti = cuti;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> fetchPalingBanyakCuti() async {
    print("ini3");
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final paling = await handler.getKaryawanPalingBanyakCuti();
      if(paling.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else {
        _state = ResultState.HasData;
        notifyListeners();
        _palingBanyakCuti.clear();
        paling.forEach((element) {
          PalingBanyakCuti cuti = PalingBanyakCuti(
              element["nomorInduk"].toString(),
              element["nama"].toString(),
              element["tanggalCuti"].toString(),
              element["keterangan"].toString()
          );
          _palingBanyakCuti.add(cuti);
          print(element.toString());
        });
        return _palingBanyakCuti;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> fetchRecent() async {
    print("ini3");
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final sisaCuti = await handler.getSisaCutiKaryawan();
      if(sisaCuti.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else {
        _state = ResultState.HasData;
        notifyListeners();
        _sisaCuti.clear();
        sisaCuti.forEach((element) {
          SisaCuti cuti = SisaCuti(
              element["nomorInduk"].toString(),
              element["nama"].toString(),
              element["lamacuti"].toString()
          );
          _sisaCuti.add(cuti);
          print(element.toString());
        });
        return _sisaCuti;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  // Future<dynamic> fetchPalingBanyakCuti() async {
  //   try {
  //     _state = ResultState.Loading;
  //     notifyListeners();
  //     final palingBanyakCuti = await handler.getKaryawanPalingBanyakCuti();
  //     if(palingBanyakCuti.isEmpty) {
  //       _state = ResultState.NoData;
  //       notifyListeners();
  //       return _message = 'Empty Data';
  //     }else {
  //       _state = ResultState.HasData;
  //       notifyListeners();
  //       _palingBanyakCuti.clear();
  //       print("jumlah " + _palingBanyakCuti.length.toString());
  //       print("jumlaha " + palingBanyakCuti.length.toString());
  //       palingBanyakCuti.forEach((element) {
  //         SisaCuti cuti = SisaCuti(
  //             element["nomorInduk"].toString(),
  //             element["nama"].toString(),
  //             element["lamacuti"].toString()
  //         );
  //         _palingBanyakCuti.add(cuti);
  //         print("ck1 " +element.toString());
  //       });
  //       print("jumlah1 " + _palingBanyakCuti.length.toString());
  //       return _palingBanyakCuti;
  //     }
  //   } catch (e) {
  //     _state = ResultState.Error;
  //     notifyListeners();
  //     return _message = 'Error --> $e';
  //   }
  // }
}