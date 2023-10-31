import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
final FirebaseStorage _storage = FirebaseStorage.instance;
class StoreData{

  Future<String> uploadImageToStorage(String childName,Uint8List file)async{
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file, required String clientNationalId, required String clientName})async{
    String resp = "some error";
    try{
     String imageUrl =  await uploadImageToStorage('clientNationalId/$clientNationalId-$clientName', file);
     resp = 'success';
     return imageUrl;
    }
        catch(err){
      resp = err.toString();
        }
        return resp;
  }


  Future<String> saveDataReport({required Uint8List file, required String outcomeName, required int amount})async{
    String resp = "some error";
    try{
      String imageUrl =  await uploadImageToStorage('outcomeReports/$outcomeName-${amount.toString()}', file);
      resp = 'success';
      return imageUrl;
    }
    catch(err){
      resp = err.toString();
    }
    return resp;
  }

  Future<String> saveDataEmployee({required Uint8List file, required String employeeName})async{
    String resp = "some error";
    try{
      String imageUrl =  await uploadImageToStorage('employee/$employeeName', file);
      resp = 'success';
      return imageUrl;
    }
    catch(err){
      resp = err.toString();
    }
    return resp;
  }

}