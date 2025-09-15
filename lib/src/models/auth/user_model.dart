

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_admin/src/models/order_model.dart';

class UserModel{
  final String? uid;
  final DocumentReference? ref;
  final String fullName;
  final String email;
  String phoneNumber;
  String userRole;
  String? profilePicture;
  String? shopName;
  String? fcmToken;
  String? shopAdress;
  String userAdress;
  bool isAvailable;
  final GeoPoint geopoint;

  // Constructor
  UserModel({
     this.uid,
     this.ref,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.userRole,
        this.profilePicture,
    required this.userAdress,
     this.shopName,
     this.shopAdress,
      required this.isAvailable,
     this.fcmToken,
     required this.geopoint
    // this.token
  });

  /// Helpers function to get the full Name

  // String get fullName => '$firstName $lastName';

  /// Static function to split full name into first and last name

   //static List <String> nameParts(fullName) => fullName.split(" ");

   /// Static function to create an empty user model
   static UserModel empty() => UserModel(uid: '', ref: null, fullName: "", email: "", phoneNumber: "", userRole: "", profilePicture: "", userAdress: "", isAvailable: true, geopoint: GeoPoint(0, 0));

   /// Convert model to JSON Structure for staring data in Firebase
   Map<String, dynamic>toJson(){
     return {
       'fullName': fullName,
       'email': email,
       'phoneNumber': phoneNumber,
       'userRole': userRole,
       'profilePicture': profilePicture,
       'userAdress': userAdress,
       'isAvailable': isAvailable,
       'fcmToken': fcmToken,
       'geopoint': geopoint,
     };
   }

   /// Factory method to create a UserMondel from a Firebase document snapshot
   factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
        if(document.data() != null){
          final data = document.data()!;
          return UserModel(
              uid: document.id,
              ref: document.reference,
              fullName: data['fullName'] ?? '',
              email: data['email'] ?? '',
              phoneNumber: data['phoneNumber'] ?? "010191009884",
              userRole: data['userRole'] ?? '',
              profilePicture: data['profilePicture'] ?? '',
              userAdress: data['userAdress'] ?? '',
              fcmToken: data['fcmToken'] ?? '',
              isAvailable: data['isAvailable'] ?? true,
              geopoint: data['geopoint'] ?? GeoPoint(0, 0)
          );
        }else {
          throw Exception("Document data is null");
        }
   }

}