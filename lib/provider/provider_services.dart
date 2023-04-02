import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices extends ChangeNotifier {
  FirebaseServices({this.sharedPreferences});
  SharedPreferences? sharedPreferences;
  UserData? _userDetail;
  UserData? get userDetail => _userDetail;
  final _auth = FirebaseAuth.instance;
  fetchUsersDetail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = await userCollection.doc(currentUser!.uid).get();

    _userDetail = UserData(
      email: userDoc.get('email'),
      password: userDoc.get('password'),
      name: userDoc.get('name'),
      gender: userDoc.get('gender'),
      dob: userDoc.get('dob'),
      height: userDoc.get('height'),
      weight: userDoc.get('weight'),
    );
    print(_userDetail!.toJson());
    notifyListeners();
    return _userDetail;
  }

  Future<void> addMedicine(BuildContext context, name, dosage, category) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.uid).collection('medicines');
    return await medicineCollection.doc().set({
      "medicine_name": name,
      "dosage": dosage,
      "category": category,
    });
  }

  Future<void> addPatient(BuildContext context, email, name, gender, dob, height, weight, uid) async {
    final CollectionReference medicineCollection = FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.uid).collection('patients');
    return await medicineCollection.doc().set({
      "email": email,
      "name": name,
      "gender": gender,
      "dob": dob,
      "height": height,
      "weight": weight
    });
  }

  // CollectionReference? _medicines;
  // CollectionReference? get medicines => _medicines;
  // CollectionReference fetchMedicines(BuildContext context) {
  //   _medicines = FirebaseFirestore.instance.collection('Users').doc(Provider.of<FirebaseServices>(context, listen: false).getUID()).collection('medicines');
  //   notifyListeners();
  //   return _medicines;
  // }

  void setUID(String uid) {
    sharedPreferences!.setString(IS_LOGGED_IN, uid);
    notifyListeners();
  }

  void setUserType(String userType) {
    sharedPreferences!.setString(USER_TYPE, userType);
    notifyListeners();
  }

  String? getUID() {
    return sharedPreferences!.getString(IS_LOGGED_IN);
  }

  String? getUserType() {
    return sharedPreferences!.getString(USER_TYPE);
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(IS_LOGGED_IN);
  }

  Future<bool> clearSharedData() async {
    _auth.signOut();
    sharedPreferences!.remove(IS_LOGGED_IN);
    return true;
  }
}
