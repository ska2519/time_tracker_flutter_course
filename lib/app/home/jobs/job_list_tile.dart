import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

//ListTile 장점 - Job 객체를 입력 인수로 사용하여 job_page에 표시되지 않는거라는데 이해 안감..
class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
