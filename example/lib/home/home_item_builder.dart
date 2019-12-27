
import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:multi_type_list_view/multi_type_list_view.dart';

import 'home_data.dart';

class TitleItemBuilder extends MultiTypeWidgetBuilder<String> {

  @override
  Widget buildWidget(BuildContext context, String item, int index) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text("Group: $item", style: TextStyle(fontSize: 20, color: Colors.lightBlue),),
    );
  }
}
class GroupMessageItemBuilder extends MultiTypeWidgetBuilder<GroupMessage> {
  final ScrollController controller;
  final OnItemTap<Message> onItemTap;

  GroupMessageItemBuilder({this.controller, this.onItemTap});

  @override
  Widget buildWidget(BuildContext context, GroupMessage item, int index) {
    if(item == null || item.messages == null || item.messages.isEmpty) return null;
    return Container(
      height: 100,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: item.messages.length,
        itemBuilder: (context, index){
          if(item.messages == null || item.messages.length < index) return Offstage();
          var message = item.messages[index];
          return InkWell(
            onTap: () {
              onItemTap(context, message, index);
            },
            child: Container(
              height: 100,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[BoxShadow(color:Colors.black45, blurRadius: 3,)]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(message.avatar, fit: BoxFit.cover, width: 80, height: 80,),
              ),
            ),
          );
        },
      ),
    );
  }

}
class BannerItemBuilder extends MultiTypeWidgetBuilder<BannerItem> {
  final OnItemTap<BannerItem> onItemTap;

  BannerItemBuilder(this.onItemTap);

  @override
  Widget buildWidget(BuildContext context, BannerItem item, int index) {
    return InkWell(
      onTap: (){
        onItemTap(context, item, index);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(item.avatar),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class BannerBuilder extends MultiTypeWidgetBuilder<List<BannerItem>> {
  final OnItemTap<BannerItem> onItemTap;

  BannerBuilder(this.onItemTap);

  @override
  Widget buildWidget(BuildContext context, List<BannerItem> item, int index) {
    return Container(
      height: 250,
      color: Colors.black45,
      child: Swiper(
        pagination: SwiperPagination(),
        viewportFraction: 0.8,
        scale: 0.9,
        itemCount: item.length,
        layout: SwiperLayout.STACK,
        outer: false,
        itemWidth: 350,
        itemHeight: 220,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: (){
                onItemTap(context, item[index], index);
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 3.0,
                        spreadRadius: 3.0
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(item[index].avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

typedef OnItemTap<T> = void Function(BuildContext context, T item, int index);

class MessageBuilder extends MultiTypeWidgetBuilder<Message> {

  final OnItemTap<Message> onItemTap;

  MessageBuilder(this.onItemTap);

  @override
  Widget buildWidget(BuildContext context, Message item, int index) {
    return Container(
      child: ListTile(
        onTap: () {
          onItemTap(context, item, index);
        },
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[BoxShadow(color:Colors.black45, blurRadius: 3,)]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(item.avatar, fit: BoxFit.cover, width: 60, height: 60,),
          ),
        ),
        title: Text(item.title),
        subtitle: Text(item.subTitle),
        trailing: Text(formatDate(item.time, [HH, ':', mm, ':', ss])),
      ),
    );
  }
}


class UpgradeAppVersionBuilder extends UnsupportedItemTypeWidgetBuilder {

  @override
  Widget buildWidget(BuildContext context, item, int index) {
    return Text('当前版本暂不支持此数据，请升级app！');
  }
}