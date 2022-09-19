import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/extra_functionality/local_storage_controller.dart';
import '../../model/user.dart';

class DatabaseOperationController extends ChangeNotifier
{
  List<AppUser> user=List.empty(growable: true);
  DatabaseOperationController(){
    getData();
  }
  Future<void> addData(String name,String email,int id)
  async {
    user.clear();
    Map<String,dynamic> data={};
    data['Name']=name;
    data['Email']=email;
    data['Id']=id;
    data['ProfileImage']='demourl';
    data['Token']='token';
    await StorageController.insertData('User',data);
    await getData();
  }
  Future<void> getData()
  async {
    user.clear();
    final result=await StorageController.getData('User',101);
    for(int i=0;i<result.length;i++){
      user.add(AppUser.fromJson(result[i] as Map<String,dynamic>));
    }
    notifyListeners();
  }
  Future<void> deleteData(int id)
  async {

    final result=await StorageController.deleteData('User',id);
    if(result>0){
      user.removeWhere((element) => element.id==id.toString());
    }
    notifyListeners();
  }
  Future<void> updateData(String name,String email,int id)
  async {
    Map<String,dynamic> data={};
    data['Name']=name;
    data['Email']=email;
    data['ProfileImage']='demourl';
    data['Token']='token';
    await StorageController.updateUser('User',data,id.toString());
    await getData();
  }
}