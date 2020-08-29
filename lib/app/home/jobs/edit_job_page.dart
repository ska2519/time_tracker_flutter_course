import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  //탐색 스택 내부에 새 경로를 푸시 // {Job job}  명명 된 매개 변수
  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    //!!!!!show를 통해 AddJobPage 에서 Context 가져오기에 여기서 Provider 생성
    //!! AddJobPage를 통해 Database 가져와야 위젯 트리에서 Material App 아래가 아닌 AddJobPage에 붙음

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final FocusNode _jobNameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  //폼에 엑세스 할때
  final _formkey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        //jobsStream().first 로  항상 첫 번째 값에 액세스 가능 async/await 함께
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        //기존 job list에서 현재 job 이름을 제외하는 것입니다.
        //create or update 페이지 지정
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: '존재하는 직업 입니다',
            content: '다른 이름을 사용해주세요',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          // ?로 job이 있으면 .id 액세스 하는거고 왜이렇게 어렵게 생각했지 나눠서 하나씩 분석하자
          //create Job 할때는 widget.job이 null이면 documentIdFromCurrentDate 사용해서 ID생성
          //?. == 액세스하기 전에 단순히 null 검사를 수행 연산자의 왼쪽이 null이 아니면 기존 id 사용 그게 아닐시(??) documentIdFromCurrentDate
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            id: id,
            name: _name,
            ratePerHour: _ratePerHour,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _jobNameEditingComplete() {
    final newFocus = _ratePerHourFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        focusNode: _jobNameFocusNode,
        onEditingComplete: _jobNameEditingComplete,
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        focusNode: _ratePerHourFocusNode,
        onEditingComplete: _submit,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        //tryParse 는 exception 발생 x return 값 null
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        keyboardType: TextInputType.numberWithOptions(
          signed: false, // 부호 X
          decimal: false, //소수점 분수 제공 X
        ),
      ),
    ];
  }
}
