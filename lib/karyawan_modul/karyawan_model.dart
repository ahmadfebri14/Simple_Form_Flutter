import 'package:flutter/cupertino.dart';
import 'package:mceasy_submission/model/user.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../database_handler.dart';


enum ResultState { Loading, NoData, HasData, Error }

class EmployeeModel extends ChangeNotifier {
 final handler = DatabaseHandler();
 List<User> _user = [];
 List<User> get user => _user;
 late ResultState _state;
 String _message = '';
 bool reserve = false;

 List<User> _recentUser = [];
 List<User> get recentUser => _recentUser;


 ResultState get state => _state;
 String get message => _message;

 EmployeeModel() {
   handler.initializeDB();
   fetchAll();
   fetchRecent();
   // fetchTop();
 }

 void sortList() {
   // user.reversed;
   if(reserve) {
     reserve = false;
   } else {
     reserve = true;
   }
   notifyListeners();
 }

 Future<void> addUser(User user) async {
   List<User> listOfUsers = [user];
   await handler.insertUser(listOfUsers);

   // getUser();
   fetchAll();
   fetchRecent();
 }

 Future<void> updateUser(User user, int id) async {
   await handler.updateUser(user);

   fetchAll();
   fetchRecent();
 }

  Future<void> deleteUser(int id) async {
    await handler.deleteUser(id);

    fetchAll();
    fetchRecent();
  }

 Future<dynamic> fetchAll() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final user = await handler.retrieveUsers();
      if(user.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else {
        _state = ResultState.HasData;
        notifyListeners();
        return _user = user;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
 }

 Future<dynamic> fetchRecent() async {
   try {
     _state = ResultState.Loading;
     notifyListeners();
     final recent = await handler.getTop3();
     if(recent.isEmpty) {
       _state = ResultState.NoData;
       notifyListeners();
       return _message = 'Empty Data';
     }else {
       _state = ResultState.HasData;
       notifyListeners();
       return _recentUser = recent;
     }
   } catch (e) {
     _state = ResultState.Error;
     notifyListeners();
     return _message = 'Error --> $e';
   }
 }
}