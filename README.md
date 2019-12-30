# MultiTypeListView

A light weight flutter customer ListView that displays multiple widget types.


[![Pub](https://img.shields.io/pub/v/multi_type_list_view.svg?style=flat-square)](https://pub.dartlang.org/packages/multi_type_list_view)

## Screenshot

| [home](example/lib/home/home.dart)          | [chat](example/lib/chat/chat.dart)          |
|:-------------------------------------------:|:-------------------------------------------:|
| <img width="300" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/home.png"> | <img width="300" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/chat.png"> |

## Getting Started

```yaml
dependencies:
  multi_type_list_view: ^0.1.0
```

## Usage

```dart
import 'package:multi_type_list_view/multi_type_list_view.dart';
```

#### 1. create a `MultiTypeListView` and initial with settings

```dart
@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiTypeListView Demo'),
      ),
      body: MultiTypeListView(
        items: items, // [required]. items in multiple types to show
        widgetBuilders: [ //[required]. your builders for each type of items
          TitleItemBuilder(),
          BannerBuilder(),
          MessageBuilder(),
          // other builders...
        ],
        // If there is no builder in [widgetBuilders] that can create widgets for a item, then that item is an unsupported item
        //  the unsupported items could be handled by [widgetBuilderForUnsupportedItemType], 
        //      create an widget for each of them, for example: create an Widget to show upgrade app version info
        //  if [widgetBuilderForUnsupportedItemType] is null, the unsupported items will be skipped
        widgetBuilderForUnsupportedItemType: UpgradeAppVersionBuilder(),
        //When [showDebugPlaceHolder] set as true(default:false), 
        //  if the building result widget for an item is null, a debug widget will be shown
        showDebugPlaceHolder: true,
         //widgetWrapper will wrap all widget build from builders for all items(except widget is null)
        widgetWrapper: (widget, item, index) {
          //for example: add a bottom border for each item widget
          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200], width: 0.5),),
            ),
            child: widget,
          );
        },
        // All parameters of the ListView.builder are supported except [ itemBuilder ]
        controller: controller,
      ),
    );
}
```

#### 2. create `MultiTypeWidgetBuilder`(s) for each type of items

For example: create 3 builders to match 3 item types for the [Demo home page](example/lib/home/home_item_builder.dart):

Item type|Builder
:-------:|:------
`String`|`TitleItemBuilder`
`List<BannerItem>`|`BannerBuilder`
`Message`|`MessageBuilder`


```dart
import 'package:flutter/material.dart';
import 'package:multi_type_list_view/multi_type_list_view.dart';

/// create a group title for item of type [ String ]
class TitleItemBuilder extends MultiTypeWidgetBuilder<String> {
  @override
  Widget buildWidget(BuildContext context, String item, int index) {
    return Container(
      padding: EdgeInsets.all(top: 20, left: 20, bottom: 5),
      child: Text(item, style: TextStyle(fontSize: 20, color: Colors.lightBlue),),
    );
  }
}

/// create a banner for item of type [ List<BannerItem> ] 
class BannerBuilder extends MultiTypeWidgetBuilder<List<BannerItem>> {
  final OnItemTap<BannerItem> onItemTap;

  BannerBuilder(this.onItemTap);

  @override
  Widget buildWidget(BuildContext context, List<BannerItem> item, int index) {
    return Container(
      height: 300,
      child: Swiper(
        //...
        itemBuilder: (context, index) {
          return Container(
            child: InkWell(
              onTap: (){
                onItemTap(context, item[index], index);
              },
              child: Container(
                //...
              ),
            ),
          );
        },
      ),
    );
  }
}

typedef OnItemTap<T> = void Function(BuildContext context, T item, int index);


/// create a message widget for item of type [ Message ] 
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
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(item.avatar, fit: BoxFit.cover, width: 60, height: 60,),
        ),
        title: Text(item.title),
        subtitle: Text(item.subTitle),
      ),
    );
  }
}
```

## Advance usage

|Code|Screenshot|
|:-------------------------------------------:|:-------------------------------------------:|
| <img width="400" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_all_code.png"> | <img width="200" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_all.png"> |
| <img width="400" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_image_none_code.png"> | <img width="200" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_image_none.png"> |
| <img width="400" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_placeholder_code.png"> | <img width="200" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_placeholder.png"> |
| <img width="400" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_unsupported_builder_code.png"> | <img width="200" src="https://raw.githubusercontent.com/luckybilly/multi_type_list_view/master/screenshot/type_unsuppored_builder.png"> |