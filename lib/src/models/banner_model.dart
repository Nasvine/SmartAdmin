import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/* final brandUuid = Uuid();
 */
class BannerModel {
  BannerModel({
    this.uuid,
    required this.application,
    required this.images,
    required this.userId,
  });

  final String? uuid;
  final String application;
  final List<String> images;
  final DocumentReference? userId;

  static BannerModel empty() => BannerModel(application: "", images: [], userId: null);

  Map<String, dynamic> toJson() {
    return {"application": application, "images": images, "userId": userId};
  }

  factory BannerModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return BannerModel(
        application: data['application'],
        images: List<String>.from(data['images'] ?? []),
        userId: data['userId'],
        uuid: document.id,
      );
    } else {
      return BannerModel.empty();
    }
  }
}
