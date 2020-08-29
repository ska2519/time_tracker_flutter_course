import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

//새로운 유형 정의 - 일반(generic) 유형인 T타입의 아이템위젯빌더 =
// 위젯을 반환하는 펑션(인수로 context와 T타입의 아이템)
// Generic(일반적인) 타입 - with different types of data models as well as different types of widgets
// 재사용 가능한 코드는 우리가 임대 한 항목에 대해 어떤 가정도하지 않음을 의미
// flutter는 입찰 패턴을 광범위하게 적용하고 원하는 경우 자체 빌더 제작 가능
// 파이어 베이스에서 AsyncSnapshot에서 받은 list의 index를 builder에 전달해서 ListView에서 위치 추적
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: ' Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    //ListView.builder에 separated로 변경해서 Divider 추가
    return ListView.separated(
      //separated 갯수는 tile 사이마다 1개씩
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),

      // index를 빌더에 전달해서 리스트에서 위치 참조
      // itemBuilder가 2번 돔 Container 2개 추가해서 separated Divider 넣기 위해
      itemBuilder: (context, index) {
        // 앞뒤로 안보이는 Container 2개 추가
        if (index == 0 || index == items.length + 1) {
          return Container();
        } // index가 2개 추가된 상태 - 1개를 지워야 1개 많음 왜냐하면 Container 추가를 위해 length +2 상태
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
