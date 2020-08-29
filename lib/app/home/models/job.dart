import 'package:flutter/foundation.dart';

//데이터 변환은 모델 클래스 내에서 수행
class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;

  // factory constructor - 클래스의 새 인스턴스를 항상 생성하지 않는 생성자를 구현할 때 사용
  // factory constructor - data가 null이면  Job 객체가 아닌 null 반환 그렇기에 객체 안으로 들어가서 체크하지 않아도 됨
  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    // 읽기-Stream
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    //쓰기-Future
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
