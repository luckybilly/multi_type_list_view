
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:multi_type_list_view/multi_type_list_view.dart';

import 'chat_data.dart';

const double kChatContentPadding = 8;
const double kChatWidgetMargin = 8;
const double kChatAvatarSize = 50;
const double kChatRadius = 5;
const double kChatContentFontSize = 16;
const double kChatNameFontSize = 12;
const Color kChatNameColor = Colors.grey;
const Color kFriendChatContentColor = Colors.black87;
const Color kFriendChatContentBgColor = Colors.white;
const Color kMyChatContentColor = Colors.white;
const Color kMyChatContentBgColor = Colors.green;
const double kChatContentMaxWidth = 250;

/// builder for time message
///
class TimeMessageBuilder extends MultiTypeWidgetBuilder<TimeMessage> {

  @override
  Widget buildWidget(BuildContext context, TimeMessage item, int index) {
    return Container(
      child: Center(
        child: Text(formatDate(item.content, [HH, ':', nn, ':', ss]), style: TextStyle(color: Colors.grey[400]),),
      ),
    );
  }
}

/// builder for image message
///
class ImageChatDetailBuilder extends MultiTypeWidgetBuilder<ImageChatDetail> {
  String _name;
  String _avatar;

  ImageChatDetailBuilder(this._name, this._avatar);

  @override
  Widget buildWidget(BuildContext context, ImageChatDetail item, int index) {
    var widget = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: kChatContentMaxWidth,
        child: Image.file(item.content,),
      ),
    );
    return buildChat(_name, _avatar, item, widget);
  }
}

/// builder for emoji message
///
class EmojiChatDetailBuilder extends MultiTypeWidgetBuilder<EmojiChatDetail> {
  String _name;
  String _avatar;

  EmojiChatDetailBuilder(this._name, this._avatar);
  @override
  Widget buildWidget(BuildContext context, EmojiChatDetail item, int index) {
    var widget = Image.asset(item.content.file, width: 32, height: 32,);
    return buildChat(_name, _avatar, item, widget);
  }
}

/// builder for string message
///
class StringChatDetailBuilder extends MultiTypeWidgetBuilder<StringChatDetail> {
  String _name;
  String _avatar;

  StringChatDetailBuilder(this._name, this._avatar);

  @override
  Widget buildWidget(BuildContext context, StringChatDetail item, int index) {
    var bg = item.current ? kMyChatContentBgColor : kFriendChatContentBgColor;
    var widget = Container(
      constraints: BoxConstraints(maxWidth: kChatContentMaxWidth,),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kChatRadius),
      ),
      padding: EdgeInsets.all(kChatContentPadding),
      child: Text(item.content,
        softWrap:true,
        style: TextStyle(
            color: item.current ? kMyChatContentColor : kFriendChatContentColor,
            fontSize: kChatContentFontSize
        ),
      ),
    );
    return buildChat(_name, _avatar, item, widget);
  }
}


class UnsupportedChatDetail extends UnsupportedItemTypeWidgetBuilder {
  String _name;
  String _avatar;

  UnsupportedChatDetail(this._name, this._avatar);

  @override
  Widget buildWidget(BuildContext context, item, int index) {
    var widget = Container(
      constraints: BoxConstraints(maxWidth: kChatContentMaxWidth,),
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        borderRadius: BorderRadius.circular(kChatRadius),
      ),
      padding: EdgeInsets.all(kChatContentPadding),
      child: Text("unsupported chat message. please upgrade your app version!",
        softWrap:true,
        style: TextStyle(
            color: Colors.white,
            fontSize: kChatContentFontSize
        ),
      ),
    );
    return buildChat(_name, _avatar, item, widget);
  }
}

Widget buildChat(String _name, String _avatar, ChatDetail item, Widget widget) {
  if(item.current) {
    return MyChat(name: kMyName, avatar: kMyAvatar, child: widget, );
  }
  return FriendChat(name: _name, avatar: _avatar, child: widget, );
}

/// widget for current user
///
class MyChat extends StatelessWidget {
  String name;
  String avatar;
  Widget child;

  MyChat({this.name, this.avatar, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kChatWidgetMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: kChatWidgetMargin),
                child: Text(name, style: TextStyle(color: kChatNameColor, fontSize: kChatNameFontSize)),
              ),
              child,
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: kChatWidgetMargin,),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kChatRadius),
              child: Image.asset(avatar, width: kChatAvatarSize, height: kChatAvatarSize,),
            ),
          ),
        ],
      ),
    );
  }
}

/// widget for friend
class FriendChat extends StatelessWidget {
  String name;
  String avatar;
  Widget child;

  FriendChat({this.name, this.avatar, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kChatWidgetMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: kChatWidgetMargin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kChatRadius),
              child: Image.asset(avatar, width: kChatAvatarSize, height: kChatAvatarSize,),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: kChatWidgetMargin),
                child: Text(name, style: TextStyle(color: kChatNameColor, fontSize: kChatNameFontSize)),
              ),
              child,
            ],
          ),
        ],
      ),
    );
  }
}

