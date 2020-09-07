import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatelessWidget {
/*  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(
        Job(name: 'Ska', ratePerHour: 8),
      );
      // 생성 실패치 유저에게 다이얼로그 알림
    } on FirebaseException catch (e) {
      print('익셉션 다이얼로그 어떻게 합치지 알아보자!' + e.toString());
      FirebaseExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => EditJobPage.show(
              context,
              database: Provider.of<DataBase>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<DataBase>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: '삭제가 실패하였습니다',
        exception: e,
      ).show(context);
    }
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<DataBase>(context);
    // StreamBuilder로 firebasestore 연결
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            //key - 위젯 기반 클래스에서 직접 오는 선택적 인수  job.id is a unique string
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              //material splash effect when Tap
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}

/*
// ListItemsBuilder 클래스 만들기전 통합 - 이해에 참조
break point ==해당 코드가 런타임에 실행될 때 프로그램의 실행을 일시 중단
if (snapshot.hasData) {
final jobs = snapshot.data;
if (jobs.isNotEmpty) {
//map 연산자는 무형객체(Iterable) 반환 / 사용하는 경우 목록으로 변환 필요 doc → job 객체로 변환
final children = jobs
    .map((job) => JobListTile(
job: job,
//material splash effect when Tap
onTap: () => EditJobPage.show(context, job: job),
))
    .toList();
return ListView(children: children);
}
}
return EmptyContent();
//StreamBuilder 사용 시 오류처리 항상!
if (snapshot.hasError) {
return Center(child: Text('Some Error occurred'));
}
return Center(child: CircularProgressIndicator());*/
