import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

//  Database API Design
//strongly typed data models such as <Job> class
//콜렉션과 문서는 데이터베이스와 관련하여하는 것처럼 엄격한 스키마를 따를 필요가 없습니다.

// TOPTIP! FB스토어 데이터 베이스와 서비스(repository)를 분리하여 데이터베이스 API는 동일하게 유지
//따라서 해당 데이터베이스를 변경해도 나머지 코드에는 영향을 미치지 않습니다.
abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<Job> jobStream({@required String jobId});
  Stream<List<Job>> jobsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

//document ID 날짜로 저장
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  // Firestore Service - repository 라고도 부름 -백엔드의 데이터에 액세스
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async => await _service.deleteData(
        path: APIPath.job(uid, job.id),
      );
  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  //gets all entries for user, optionally filtering by job
  //job 인수로 필터링해서 job이 있는 항목만 스트림
  Stream<List<Entry>> entriesStream({Job job}) => _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            //jobId 값이 있는 entry 값을 entries list로 만듬 - queryBuilder로 필터링
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        //jobId로 필터링 된 entries data에서 entryId(documentId)를 스트림하는 빌더
        builder: (data, documentId) => Entry.fromMap(data, documentId),
        //  list.dart안에 있는 sort 메서드로 지정한 순서(lhs, rhs)에 따라 목록을 정렬
        // Stream<List<Entry>> 안의 1hs는 시작 rhs는 끝 - 시작일자로 비교해서 정렬(sorting)
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
