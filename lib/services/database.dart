import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  Future<void> createJob(Job job) async => await _setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );
  // _setData 메소드는 많은 복사 붙여 넣기 코드를 피하는 좋은 방법
  //_setData() defines a single entry point for all writers to Firestore (useful for logging/debugging)
  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}

/* ↑↑↑↑↑↑↑ createJob + _setData 과 동일
Future<void> createJob(Job job) async {
  final path = APIPath.job(uid, 'job_abc');
  //싱글톤 으로 firestore 엑세스
  final documentReference = FirebaseFirestore.instance.doc(path);
  await documentReference.set(job.toMap());
}*/
