import 'dart:ui';

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
    if (name == null) {
      return null;
    }
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

  //해시코드는 객체의 정수 표현
  //해시코드 flutter 내부의 클래스 구현 방법
  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  //implement the equality operator
  //등호 연산자는 왼쪽과 오른쪽 인수 사이에 호출되며 이는 Job 클래스에 대해 등식 연산자를 구현했기 때문에 작동합니다.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    //다른 개체가 현재 개체와 동일한 유형인지 확인
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id && name == otherJob.name && ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
