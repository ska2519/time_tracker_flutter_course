import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  //only be accessible by a single DOM object - Firestore 통신 시 필요한 여러 클래스를 생성 염려
  //↓↓↓ private constructor - 이 파일 외부에서 생성되지 않은 다음 싱글 톤을 정적 최종 객체로 선언
  FirestoreService._();
  //FirestoreService 싱글 톤 생성
  static final instance = FirestoreService._();

  // _setData 메소드는 많은 복사 붙여 넣기 코드를 피하는 좋은 방법
  //_setData() defines a single entry point for all writers to Firestore (useful for logging/debugging)
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  // helper method generic on type T
  Stream<List<T>> collectionStream<T>({
    @required String path,
    //builder to generate a model object from our data.
    @required T builder(Map<String, dynamic> data, String documentId),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      // query 일치하지 않는 모든 객체 필터링
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          //jobId로 필터링 된 entries data에서 entryId(documentId)를 스트림하는 빌더
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        //스트림 안에서 원하는 String(class인 dateTime or length) 값으로 정렬
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}

// docSnapshot에 있는 리스트를 각각의 Job 으로 생성
//Firestore 문서의 키 값 쌍을 데이터로 변환하는 방법
//map 연산자는 Iterable 반환 toList()로 명시적 변환 필요

/* ↑↑↑↑↑↑↑ createJob + _setData 과 동일
  Future<void> createJob(Job job) async {
    final path = APIPath.job(uid, 'job_abc');
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(job.toMap());
  }*/

/*
{
final path = APIPath.jobs(uid);
final reference = FirebaseFirestore.instance.collection(path);
final snapshots = reference.snapshots();

return snapshots.map(
(snapshot) {
// docSnapshot 으로 변환
return snapshot.docs
    .map(
// docSnapshot에 있는 리스트를 각각의 Job 으로 생성
//Firestore 문서의 키 값 쌍을 데이터로 변환하는 방법
(snapshot) => Job.fromMap(snapshot.data()),
) //map 연산자는 Iterable 반환 toList()로 명시적 변환 필요
    .toList();
},
);
}*/
