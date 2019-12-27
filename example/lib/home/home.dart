
import 'package:flutter/material.dart';
import 'package:multi_type_list_view/multi_type_list_view.dart';
import 'package:multi_type_list_view_example/chat/chat.dart';
import 'package:multi_type_list_view_example/chat/input_block.dart';
import 'package:provider/provider.dart';

import 'home_data.dart';
import 'home_item_builder.dart';

class Home extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  var items = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _initData().then((list){
      setState(() {
        items = list;
      });
    });
  }

  Future<List> _initData() async{
    var messages = Message.getMessages();
    var bannerItems = BannerItem.getBannerItems();
    return [
      'Banner',
      bannerItems,
      messages[0],
      'Horizontal List',
      GroupMessage(messages),
      ...messages.sublist(1, 3),
      'Single Ad',
      bannerItems[2],
      ...messages.sublist(4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var onMessageTap = (context, item, index){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => InputState(),)
            ],
            child:Chat(friendName: item.title, friendAvatar: item.avatar,)
        );
      }));
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiTypeListView Demo'),
      ),
      body: MultiTypeListView(
        items: items,
        widgetBuilders: [
          TitleItemBuilder(),
          BannerItemBuilder(onMessageTap),
          BannerBuilder(onMessageTap),
          GroupMessageItemBuilder(controller: controller, onItemTap: onMessageTap),
          MessageBuilder(onMessageTap),
        ],
        showDebugPlaceHolder: true,
        widgetBuilderForUnsupportedItemType: UpgradeAppVersionBuilder(),
        widgetWrapper: (widget, item, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200], width: 1),
              ),
            ),
            child: widget,
          );
        },
        // All parameters of the ListView.builder are supported except [ itemBuilder ]
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
