import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/extra_functionality/local_storage_controller.dart';
import 'package:flutter_sample/model/user.dart';

class DatabaseOperationController extends ChangeNotifier {
  List<AppUser> user = List.empty(growable: true);
  DatabaseOperationController() {
    getData();
  }
  @override
  void dispose() {
    user.clear();
    super.dispose();
  }

  Future<void> addData(String name, String email, int id) async {
    AppUser addUser = new AppUser();
    addUser.name = name;
    addUser.email = email;
    addUser.id = '$id';
    await StorageController.insertData('User', addUser.toJson());
    await getData();
  }

  Future<void> getData() async {
    user.clear();
    final result = await StorageController.getData('User');
    for (int i = 0; i < result.length; i++) {
      user.add(AppUser.fromJson(result[i] as Map<String, dynamic>));
    }
    notifyListeners();
  }

  Future<void> deleteData(int id) async {
    final result = await StorageController.deleteData('User', id);
    if (result > 0) {
      user.removeWhere((element) => element.id == id.toString());
    }
    notifyListeners();
  }

  Future<void> updateData(String name, String email, int id) async {
    AppUser addUser = new AppUser();
    addUser.name = name;
    addUser.email = email;
    addUser.id = '$id';
    await StorageController.updateUser('User', addUser.toJson(), id.toString());
    await getData();
  }
}
